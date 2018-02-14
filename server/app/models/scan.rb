class Scan < ApplicationRecord
  belongs_to :project
  has_many :dependencies, dependent: :destroy
  validates_uniqueness_of :id
  validates :needs_update, inclusion: { in: %w(no major minor auto normal) }
end
