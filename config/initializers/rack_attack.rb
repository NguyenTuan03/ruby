class Rack::Attack
  # Sử dụng MemoryStore để Rack::Attack lưu trữ số lần request ở môi trường local (Development)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # 1. KHU VỰC MIỄN TRỪ (Safelist)
  # 🚨 LƯU Ý KHI TEST: Bạn phải COMMENT dòng safelist dưới đây khi muốn kiểm thử tính năng Rate Limiting ở Local.
  # Nếu không, IP localhost (127.0.0.1) sẽ luôn được bỏ qua và không bao giờ bị chặn!
  # safelist('allow from localhost') do |req|
  #   '127.0.0.1' == req.ip || '::1' == req.ip
  # end

  # 2. GIỚI HẠN CHUNG TOÀN HỆ THỐNG (Throttle general requests)
  # Mặc định: Mỗi địa chỉ IP được gọi tối đa 100 request / 1 phút.
  throttle('req/ip', limit: ENV.fetch("GLOBAL_RATE_LIMIT", 100).to_i, period: ENV.fetch("GLOBAL_RATE_PERIOD", 1.minute).to_i) do |req|
    req.ip
  end

  # 3. BẢO VỆ NGHIÊM NGẶT CÁC ENDPOINT NHẠY CẢM (Brute-force protection)
  # Ví dụ: Chống spam tạo sản phẩm hoặc dò mật khẩu đăng nhập.
  
  # Mỗi IP chỉ được gọi API POST /products tối đa 5 lần / 20 giây.
  throttle('create_product/ip', limit: ENV.fetch("PRODUCT_RATE_LIMIT", 5).to_i, period: ENV.fetch("PRODUCT_RATE_PERIOD", 20.seconds).to_i) do |req|
    if req.path == '/products' && req.post?
      req.ip
    end
  end
  
  # Mỗi IP chỉ được gọi API POST /login tối đa 5 lần / 20 giây để chống brute-force mật khẩu.
  throttle('login/ip', limit: ENV.fetch("LOGIN_RATE_LIMIT", 5).to_i, period: ENV.fetch("LOGIN_RATE_PERIOD", 20.seconds).to_i) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end

  Rack::Attack.throttled_responder = lambda do |request|
    [
      429, 
      { 'Content-Type' => 'application/json' },
      [{
        success: false,
        message: 'Gửi nhiều quá, thử lại sau',
        data: nil,
        errors: ['Rate limit exceeded. Please try again later.']
      }.to_json]
    ]
  end

  # Customize what happens when a client is completely blocklisted
  Rack::Attack.blocklisted_responder = lambda do |request|
    [
      403, 
      { 'Content-Type' => 'application/json' },
      [{
        success: false,
        message: 'Ngu ngơ quá, không cho truy cập',
        data: nil,
        errors: ['Access denied. Your IP has been blocked.']
      }.to_json]
    ]
  end
end