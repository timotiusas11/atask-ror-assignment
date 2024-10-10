class Team < ApplicationRecord
  has_one :wallet, as: :owner, dependent: :destroy
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  after_create :initialize_wallet

  private

  def initialize_wallet
    create_wallet(balance: 0)
  end
end
