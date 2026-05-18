class ProductMailer < ApplicationMailer
  default from: "notifications@example.com"

  def register_success
    #params được truyền từ lúc gọi ProductMailer.with
    @product = params[:product]
    @subscriber = params[:subscriber]

    mail(to: @subscriber.email, subject: "Đăng ký thành công sản phẩm #{@product.name}")
  end
end
