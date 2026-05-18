class Subscriber < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :subscriptions, dependent: :destroy
  has_many :products, through: :subscriptions
end
