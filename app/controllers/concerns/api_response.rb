module ApiResponse
  extend ActiveSupport::Concern

  included do
    # Tắt xác thực CSRF token để phục vụ clients API (React, Vue, Postman, curl...)
    skip_before_action :verify_authenticity_token, raise: false

    # Tự động bắt lỗi không tìm thấy bản ghi (RecordNotFound) và trả về JSON chuẩn
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  end

  # API success
  def render_success(data: nil, message: "Success", status: :ok)
    render json: {
      success: true,
      message: message,
      data: data,
      errors: nil
    }, status: status
  end

  # API failure
  def render_error(message: "Error", errors: nil, status: :unprocessable_entity)
    render json: {
      success: false,
      message: message,
      data: nil,
      errors: errors
    }, status: status
  end

  # API pagination (Phân trang tự động dựa trên ActiveRecord Relation)
  def render_paginated(scope, message: "Success", status: :ok)
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    page = 1 if page < 1
    per_page = 10 if per_page < 1

    total_count = scope.count
    total_pages = (total_count.to_f / per_page).ceil
    records = scope.offset((page - 1) * per_page).limit(per_page)

    render json: {
      success: true,
      message: message,
      data: records,
      meta: {
        current_page: page,
        per_page: per_page,
        total_pages: total_pages,
        total_count: total_count
      },
      errors: nil
    }, status: status
  end

  private

  # Hàm xử lý tự động khi không tìm thấy bản ghi
  def render_record_not_found(exception)
    render_error(message: "Không tìm thấy bản ghi trong hệ thống", errors: exception.message, status: :not_found)
  end
end
