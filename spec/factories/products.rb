FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Sản phẩm Test số #{n}" }
    price { 150000 }
    inventory { 100 }
  end
end
