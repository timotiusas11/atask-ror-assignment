class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :transactions_as_source, class_name: 'Transaction', foreign_key: 'source_wallet_id', dependent: :destroy
  has_many :transactions_as_target, class_name: 'Transaction', foreign_key: 'target_wallet_id', dependent: :destroy

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def calculate_balance
    transactions_as_target.sum(:amount) - transactions_as_source.sum(:amount)
  end
end
