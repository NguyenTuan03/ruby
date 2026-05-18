class ProductsController < ApplicationController
  include Pagy::Method
  include ApiResponse

  before_action :authorize_request, except: %i[index show]
  before_action :require_worker, only: %i[create update destroy]
  before_action :set_product, only: %i[show update destroy]

  # GET /products
  def index
    limit_items = params.fetch(:limit, 20).to_i
    @pagy, @products = pagy(Product.all, limit: limit_items)

    render_paginated(@pagy, @products, message: "Lấy danh sách sản phẩm thành công")
  end

  # GET /products/1
  def show
    render_success(data: @product, message: "Lấy thông tin sản phẩm thành công")
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render_success(data: @product, message: "Tạo sản phẩm thành công", status: :created)
    else
      render_error(message: "Không thể tạo sản phẩm", errors: @product.errors.full_messages, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render_success(data: @product, message: "Cập nhật sản phẩm thành công")
    else
      render_error(message: "Không thể cập nhật sản phẩm", errors: @product.errors.full_messages, status: :unprocessable_entity)
    end
  end

  # DELETE /products/1
  def destroy
    if @product.destroy
      render_success(message: "Xóa sản phẩm thành công")
    else
      render_error(message: "Không thể xóa sản phẩm")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :price, :inventory ])
    end
end
