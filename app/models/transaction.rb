class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[Deposit Withdraw Transfer] }

  validate :validate_transaction

  before_create :process_transaction

  private

  def validate_transaction
    case transaction_type
    when 'Deposit'
      if source_wallet.present?
        errors.add(:source_wallet, "harus kosong untuk Deposit")
      end
      if target_wallet.nil?
        errors.add(:target_wallet, "harus diisi untuk Deposit")
      end
    when 'Withdraw'
      if target_wallet.present?
        errors.add(:target_wallet, "harus kosong untuk Withdraw")
      end
      if source_wallet.nil?
        errors.add(:source_wallet, "harus diisi untuk Withdraw")
      end
    when 'Transfer'
      if source_wallet.nil? || target_wallet.nil?
        errors.add(:base, "Source dan Target Wallet harus diisi untuk Transfer")
      end
      if source_wallet == target_wallet
        errors.add(:base, "Source dan Target Wallet harus berbeda untuk Transfer")
      end
    else
      errors.add(:transaction_type, "jenis transaksi tidak valid")
    end
  end

  def process_transaction
    ActiveRecord::Base.transaction do
      case transaction_type
      when 'Deposit'
        target_wallet.increment!(:balance, amount)
      when 'Withdraw'
        if source_wallet.balance < amount
          errors.add(:source_wallet, "tidak memiliki saldo cukup")
          raise ActiveRecord::Rollback
        end
        source_wallet.decrement!(:balance, amount)
      when 'Transfer'
        if source_wallet.balance < amount
          errors.add(:source_wallet, "tidak memiliki saldo cukup")
          raise ActiveRecord::Rollback
        end
        source_wallet.decrement!(:balance, amount)
        target_wallet.increment!(:balance, amount)
      end
    end
  end
end
