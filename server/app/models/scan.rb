class Scan < ApplicationRecord
  belongs_to :project
  has_many :dependencies, dependent: :destroy
  validates_uniqueness_of :id
end
