class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Pagy::Method
  include ApiResponse

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    if header.blank?
      render_error(message: "Yêu cầu cung cấp token xác thực", status: :unauthorized)
      return
    end

    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render_error(message: "Không tìm thấy người dùng", status: :unauthorized)
    rescue JWT::DecodeError => e
      render_error(message: "Token không hợp lệ hoặc đã hết hạn", status: :unauthorized)
    end
  end

  def require_admin
    unless @current_user.admin?
      render_error(message: "Chỉ có admin mới có quyền truy cập", status: :unauthorized)
    end
  end

  def require_worker
    unless @current_user.worker?
      render_error(message: "Chỉ có worker mới có quyền truy cập", status: :unauthorized)
    end
  end
end
