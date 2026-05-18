# Preview all emails at http://localhost:3000/rails/mailers/product_mailer
class ProductMailerPreview < ActionMailer::Preview
  def register_success
    product = Product.first || Product.new(name: "Sản phẩm Demo", price: 150000)
    subscriber = Subscriber.first || Subscriber.new(email: "demo@example.com")
    ProductMailer.with(product: product, subscriber: subscriber).register_success
  end
end
