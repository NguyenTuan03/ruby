class Subscription < ApplicationRecord
  validates :subscriber_id, uniqueness: { scope: :product_id, message: "Đã đăng ký sản phẩm này rồi!" }

  belongs_to :product
  belongs_to :subscriber
end
   