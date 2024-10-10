class User < ApplicationRecord
  belongs_to :team, optional: true
  has_one :wallet, as: :owner, dependent: :destroy

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  after_create :initialize_wallet

  private

  def initialize_wallet
    create_wallet(balance: 0)
  end
end
