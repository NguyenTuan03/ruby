# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

puts "1. Đang thiết lập danh sách Roles..."
admin_role = Role.find_or_create_by!(name: 'admin', description: 'Quản trị viên toàn hệ thống')
worker_role = Role.find_or_create_by!(name: 'worker', description: 'Nhân viên quản lý kho và sản phẩm')
customer_role = Role.find_or_create_by!(name: 'customer', description: 'Khách hàng mua sắm')

puts "2. Đang tạo tài khoản Admin khởi thủy..."
# Khởi tạo user nếu chưa tồn tại
admin_user = User.find_or_initialize_by(email: 'admin@gmail.com')

if admin_user.new_record?
  admin_user.password = '123456'
  admin_user.save!
  puts "   -> Đã tạo tài khoản: admin@gmail.com"
else
  puts "   -> Tài khoản Admin đã tồn tại."
end

puts "3. Đang cấp quyền phân quyền..."
# Kiểm tra và gán quyền admin
unless admin_user.has_role?('admin')
  admin_user.user_roles.create!(role: admin_role)
  puts "   -> Đã gán quyền [Admin] thành công!"
end

puts "Hoàn tất quá trình Seed Database! 🚀"