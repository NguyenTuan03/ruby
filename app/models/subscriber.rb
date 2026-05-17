class Subscriber < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :products, through: :subscriptions
end
