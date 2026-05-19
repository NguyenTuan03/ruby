require "net/http"
require "uri"

class DiscordNotificationJob < ApplicationJob
  queue_as :default

  DISCORD_URL = "https://discord.com/api/webhooks/1506121895555109026/ZFqctPAkeG1cqGz8wVlqwIalfbGf7HmJHPqOBNrTqqcZXeXcF51huYgRgwMsANMusbfm"
  # Nên đưa URL này vào file .env trong thực tế để bảo mật
  DISCORD_WEBHOOK_URL = DISCORD_URL.freeze

  def perform(product_name, product_price, inventory)
    # Đây là format chuẩn mà Discord yêu cầu
    payload = {
      content: "📣 **Có một sản phẩm mới vừa được thêm vào kho!**",
      embeds: [
        {
          title: product_name,
          color: 3066993, # Mã màu xanh lá cây (Decimal)
          fields: [
            {
              name: "💰 Giá bán",
              value: "#{product_price} VND",
              inline: true
            },
            {
              name: "📦 Tồn kho",
              value: "#{inventory} sản phẩm",
              inline: true
            }
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
