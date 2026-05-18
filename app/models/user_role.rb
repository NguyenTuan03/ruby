class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  # Đảm bảo 1 user không bị gán 1 role 2 lần
  validates :role_id, uniqueness: { scope: :user_id }
end
