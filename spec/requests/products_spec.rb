require 'rails_helper'

RSpec.describe "Products APIs", type: :request do
  describe "GET /products" do
    it "trả về danh sách sản phẩm thành công với cấu trúc JSON chuẩn" do
      # 1. ARRANGE (Chuẩn bị): Tạo sẵn 3 sản phẩm trong database test
      FactoryBot.create_list(:product, 3)

      # 2. ACT (Thực thi): Đóng giả một client gọi thẳng vào API
      get '/products'

      # 3. ASSERT (Kỳ vọng): Kiểm tra kết quả trả về
      # - Kiểm tra mã HTTP phải là 200 OK
      expect(response).to have_http_status(:ok)

      # - Phân tích dữ liệu JSON trả về
      json_response = JSON.parse(response.body)

      # - Kiểm tra các key bắt buộc phải có trong module ApiResponse của bạn
      expect(json_response['success']).to eq(true)
      expect(json_response['message']).to eq("Lấy danh sách sản phẩm thành công")

      # - Kiểm tra xem data có chứa đúng 3 sản phẩm không
      expect(json_response['data'].length).to eq(3)

      # - Kiểm tra dữ liệu Meta của Pagy
      expect(json_response['meta']).to include(
        'current_page' => 1,
        'total' => 3
      )
    end
  end
end
