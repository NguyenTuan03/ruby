class Admin::UserRolesController < ApplicationController
  include ApiResponse

  before_action :authorize_request
  before_action :require_admin
  
  # GET /admin/users/:user_id/roles
  def index
    target_user = User.find(params[:user_id])
    # Lấy tất cả các role của user
    roles = target_user.roles.pluck(:name)
    # Trả về JSON danh sách các role
    render_success(message: "Danh sách roles của #{target_user.email}", data: roles)
    
    rescue ActiveRecord::RecordNotFound
      render_error(message: "Không tìm thấy User tương ứng", status: :not_found)
  end

  # POST /admin/users/:user_id/roles
  def create
    target_user = User.find(params[:user_id])
    role = Role.find_by!(name: params[:role_name])

    user_role = target_user.user_roles.new(role: role)
    if user_role.save
      render_success(message: "Đã cấp quyền #{role.name} cho #{target_user.email}")
    else
      render_error(message: "Cấp quyền thất bại", errors: user_role.errors.full_messages, status: :unprocessable_entity)
    end

    rescue ActiveRecord::RecordNotFound
      render_error(message: "Không tìm thấy User hoặc Role tương ứng", status: :not_found)
  end
end
