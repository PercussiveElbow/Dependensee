class Scan < ApplicationRecord
  belongs_to :project
  has_many :dependencies, dependent: :destroy
  # validates_presence_of :source
  validates_uniqueness_of :id
end
