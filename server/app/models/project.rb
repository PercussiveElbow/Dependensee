class Project < ApplicationRecord

  has_many :scans
  validates_presence_of :name,:owner,:language
end
