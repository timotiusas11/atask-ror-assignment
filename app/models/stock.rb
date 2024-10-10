class Stock < ApplicationRecord
  has_one :wallet, as: :owner, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  after_create :initialize_wallet

  private

  def initialize_wallet
    create_wallet(balance: 0)
  end
end
