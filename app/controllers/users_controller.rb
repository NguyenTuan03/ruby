class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render_success(data: user, message: "Đăng ký tài khoản thành công", status: :created)
    else
      render_error(message: "Đăng ký tài khoản thất bại", errors: user.errors.full_messages, status: :unprocessable_entity)
    end
  end

  private

  def user_params
    permitted = params.permit(:email, :password)
    permitted[:password] = permitted[:password].to_s if permitted[:password].present?
    permitted
  end
end
