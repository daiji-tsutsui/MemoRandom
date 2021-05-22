class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
