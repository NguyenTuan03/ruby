class SubscriptionsController < ApplicationController
  include ApiResponse
  include Pagy::Method

  before_action :authorize_request, except: %i[index]
  before_action :set_product

  # GET: /products/:product_id/subscriptions
  def index
    limit_items = params.fetch(:limit, 20).to_i
    @pagy, @subscribers = pagy(@product.subscribers, limit: limit_items)

    render_paginated(@pagy, @subscribers, message: "Lấy danh sách đăng ký thành công")
  end

  # POST: /products/:product_id/subscriptions
  def create
    email = params.dig(:subscription, :email)

    if email.blank?
      render_error(message: "Email không được để trống", status: :bad_request)
      return
    end

    # in case the network is not stable, use transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      # Find or create subscriber
      subscriber = Subscriber.find_or_create_by!(email: email)
      
      subscription = @product.subscriptions.new(subscriber: subscriber)

      # Dùng save! để kích hoạt ActiveRecord::RecordInvalid ngoại lệ khi validate thất bại,
      # giúp rollback toàn bộ transaction tự động.
      subscription.save!
      
      # Gửi email thông báo đăng ký thành công (bằng deliver_later để chạy bất đồng bộ)
      ProductMailer.with(product: @product, subscriber: subscriber).register_success.deliver_later

      render_success(data: { subscriber: subscriber, subscription: subscription, product: @product }, message: "Đăng ký thành công", status: :created)
    end

  rescue ActiveRecord::RecordInvalid => e
    # Bắt lỗi nếu find_or_create_by! hoặc save! thất bại (ví dụ: email sai định dạng hoặc trùng lặp đăng ký)
    render_error(message: "Lỗi dữ liệu", errors: [e.message], status: :unprocessable_entity)
  rescue StandardError => e
    # Bắt các lỗi hệ thống khác để API không bị crash trả về HTML
    render_error(message: "Đã xảy ra lỗi hệ thống", errors: [e.message], status: :internal_server_error)
  end

  private

  def set_product
    @product = Product.find(params.expect(:product_id))
  end
end