class Project < ApplicationRecord
  has_many :scans, dependent: :destroy
  validates_presence_of :name,:owner,:language
  validates :name, length: { minimum: 3, maximum: 20 }
  validates :description, length: { maximum: 30 }
  validates :language, inclusion: { in: %w(Java Ruby Python) }

end
