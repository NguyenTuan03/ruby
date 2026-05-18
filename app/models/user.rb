class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def admin?
    has_role?(:admin)
  end

  def worker?
    has_role?(:worker)
  end
end
