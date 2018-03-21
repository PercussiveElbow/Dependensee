class Dependency < ApplicationRecord
  belongs_to :scan
  validates_presence_of :name,:version, :raw
end
