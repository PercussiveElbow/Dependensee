class Scan < ApplicationRecord
  belongs_to :project
  has_many :dependencies

end
