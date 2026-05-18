class User < ApplicationRecord
  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

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
