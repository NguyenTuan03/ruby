require "net/http"
require "uri"

class DiscordNotificationSubscriptionJob < ApplicationJob
  queue_as :default

  # Đọc Webhook URL từ file .env để bảo mật thông tin nhạy cảm
  DISCORD_WEBHOOK_URL = ENV["DISCORD_WEBHOOK_URL"].freeze

  def perform(email, product_name)
    # Đây là format chuẩn mà Discord yêu cầu
    payload = {
      content: "📣 **Có 1 người dùng đăng kí thành công!!**",
      embeds: [
        {
          title: email,
          color: 3066993, # Mã màu xanh lá cây (Decimal)
          fields: [
            {
              name: " 📦 Sản phẩm đăng ký",
              value: product_name,
              inline: true
            },
          ],
          timestamp: Time.current.iso8601
        }
      ]
    }

    # Thực hiện gọi HTTP POST tới Discord
    uri = URI.parse(DISCORD_WEBHOOK_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true # Discord yêu cầu HTTPS

    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = payload.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("🔴 Lỗi gửi Discord Webhook: #{response.body}")
    end
  end
end
