class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_secure_password # Adds support for password authentication
  has_secure_token :auth_token

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
