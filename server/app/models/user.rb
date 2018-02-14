class User < ApplicationRecord
  has_secure_password
  has_many :projects, foreign_key: :owner
  validates_presence_of :name, :email, :password_digest
  validates :name, length: { minimum: 3, maximum: 25 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end
