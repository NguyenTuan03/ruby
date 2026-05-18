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
  def render_paginated(pagy_objects, data, message: "Success", status: :ok)
    render json: {
      success: true,
      message: message,
      data: data,
      meta: {
        current_page: pagy_objects.page,
        limit: pagy_objects.limit,
        pages: pagy_objects.pages,
        total: pagy_objects.count,
        next_page: pagy_objects.next,
        prev_page: pagy_objects.previous
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
