class Project < ApplicationRecord
  has_many :scans, dependent: :destroy
  validates_presence_of :name,:owner,:language
end
