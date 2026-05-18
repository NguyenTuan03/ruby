# ==============================================================================
# Makefile cho dự án Ruby on Rails (PostgreSQL & Docker)
# Hỗ trợ quản lý Server, Database Migrations, Console và các lệnh Docker tiện ích.
# ==============================================================================

.PHONY: dev server console migration migrate rollback db-status add-field remove-field db-reset test clean help db-up db-down db-logs db-setup scaffold seed

# Mặc định hiển thị danh sách các lệnh
help:
	@echo "=============================================================================="
	@echo "                       RAILS DEVELOPMENT MAKEFILE                             "
	@echo "=============================================================================="
	@echo "Các lệnh khả dụng:"
	@echo "  make dev                 - Khởi động Rails Development Server"
	@echo "  make console             - Mở Rails Console (Interactive Ruby Environment)"
	@echo "  make scaffold name=... args=... [opts=...] - Tạo nhanh Model, Controller, View & Migration"
	@echo "  make migration name=...  - Tạo một file migration mới"
	@echo "  make migrate             - Thực thi tất cả migration chưa chạy"
	@echo "  make rollback [step=N]   - Hoàn tác (rollback) database migration gần nhất"
	@echo "  make db-status           - Kiểm tra trạng thái các file migrations"
	@echo "  make db-reset            - Reset database (drop, create, migrate, seed)"
	@echo "  make add-field name=... args=... - Tạo migration thêm field(s) vào bảng"
	@echo "  make remove-field name=... args=... - Tạo migration xóa field(s) khỏi bảng"
	@echo "  make test                - Chạy toàn bộ test suite của ứng dụng"
	@echo "  make clean               - Dọn dẹp logs và temporary files"
	@echo "------------------------------------------------------------------------------"
	@echo "Các lệnh Docker Database (PostgreSQL):"
	@echo "  make db-up               - Khởi động container PostgreSQL"
	@echo "  make db-down             - Dừng container PostgreSQL"
	@echo "  make db-logs             - Xem log thời gian thực của PostgreSQL container"
	@echo "  make db-setup            - Khởi động DB và chạy rails db:prepare lần đầu"
	@echo "=============================================================================="
	@echo "Ví dụ:"
	@echo "  make seed                - Chạy seed database"
	@echo "  make scaffold name=Book args=\"title:string price:decimal author:string\""
	@echo "  make scaffold name=Product args=\"name:string price:decimal\" opts=\"--api\""
	@echo "  make migration name=CreateUsers"
	@echo "  make add-field name=AddAgeToUsers args=\"age:integer status:string\""
	@echo "  make remove-field name=RemoveAgeFromUsers args=\"age:integer\""
	@echo "  make rollback step=2"
	@echo "=============================================================================="

# Khởi chạy server
dev server:
	@echo "🚀 Đang khởi động Rails server..."
	@bundle exec rails server -b 0.0.0.0

# Vào rails console
console c:
	@echo "💻 Đang mở Rails console..."
	@bundle exec rails console

# Create Model
model:
ifndef name
	$(error ❌ Thiếu tham số 'name'. Ví dụ: make model name=Role args="name:string description:string")
endif
	@echo "🏗️  Đang tạo Model cho: $(name)..."
	@bundle exec rails g model $(name) $(args)

# Tạo Scaffold (Model, Controller, View, Migration)
scaffold:
ifndef name
	$(error ❌ Thiếu tham số 'name'. Ví dụ: make scaffold name=Book args="title:string price:decimal")
endif
	@echo "🏗️  Đang tạo Scaffold cho: $(name)..."
	@bundle exec rails generate scaffold $(name) $(args) $(opts)

# Tạo migration chung
migration:
ifndef name
	$(error ❌ Thiếu tham số 'name'. Vui lòng dùng: make migration name=TenMigration)
endif
	@echo "🛠️  Đang tạo migration mới: $(name)..."
	@bundle exec rails generate migration $(name)

# Chạy migration
migrate:
	@echo "🗄️  Đang chạy database migrations..."
	@bundle exec rails db:migrate

# Rollback migration
rollback:
	@echo "🔙 Đang rollback database..."
	@bundle exec rails db:rollback $(if $(step),STEP=$(step),)

# Xem trạng thái database migrations
db-status:
	@echo "📊 Kiểm tra trạng thái migrations..."
	@bundle exec rails db:migrate:status

# Thêm field(s) vào bảng
add-field:
ifndef name
	$(error ❌ Thiếu tham số 'name'. Ví dụ: make add-field name=AddAgeToUsers args="age:integer")
endif
ifndef args
	$(error ❌ Thiếu tham số 'args'. Ví dụ: make add-field name=AddAgeToUsers args="age:integer")
endif
	@echo "➕ Đang tạo migration để thêm cột..."
	@bundle exec rails generate migration $(name) $(args)

# Xóa field(s) khỏi bảng
remove-field:
ifndef name
	$(error ❌ Thiếu tham số 'name'. Ví dụ: make remove-field name=RemoveAgeFromUsers args="age:integer")
endif
ifndef args
	$(error ❌ Thiếu tham số 'args'. Ví dụ: make remove-field name=RemoveAgeFromUsers args="age:integer")
endif
	@echo "➖ Đang tạo migration để xóa cột..."
	@bundle exec rails generate migration $(name) $(args)

# Reset Database
db-reset:
	@echo "⚠️  Đang reset database (xóa, tạo lại và chạy seed)..."
	@bundle exec rails db:reset

# Chạy test suite
test:
	@echo "🧪 Đang chạy unit tests..."
	@bundle exec rails test

# Dọn dẹp logs và tmp files
clean:
	@echo "🧹 Đang dọn dẹp log và tmp files..."
	@bundle exec rails log:clear tmp:clear

# ==============================================================================
# Docker PostgreSQL Management
# ==============================================================================

# Khởi chạy PostgreSQL Container
db-up:
	@echo "🐘 Đang khởi chạy PostgreSQL container..."
	@docker-compose up -d db

# Dừng PostgreSQL Container
db-down:
	@echo "🛑 Đang dừng PostgreSQL container..."
	@docker-compose down

# Xem log của database PostgreSQL
db-logs:
	@echo "📊 Đang xem log của PostgreSQL..."
	@docker-compose logs -f db

# Tạo database và chạy migrations lần đầu
db-setup: db-up
	@echo "⚙️  Đang thiết lập cơ sở dữ liệu Rails..."
	@sleep 3
	@bundle exec rails db:prepare

# Create mailers for sending email
mailer ${name}:
	@echo "📧 Tạo mailer..."
	@bundle exec rails g mailer ${name}

mailer-view ${name} ${action}:
	@echo "📧 Tạo mailer view..."
	@bundle exec rails g mailer ${name} ${action}

# Run seeders
seed:
	@echo "🌱 Đang chạy seed database..."
	@bundle exec rails db:seed
