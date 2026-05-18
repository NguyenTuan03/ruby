class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      time = 24.hours.from_now
      
      render_success(
        data: {
          token: token,
          exp: time.strftime("%Y-%m-%d %H:%M:%S"),
          user: {
            id: user.id,
            email: user.email
          }
        },
        message: "Đăng nhập thành công"
      )
    else
      render_error(message: "Email hoặc mật khẩu không chính xác", status: :unauthorized)
    end
  end
end
