
class User < ApplicationRecord
  has_secure_password
  has_many :projects, foreign_key: :owner
  validates_presence_of :name, :email, :password_digest
end
