class Dependency < ApplicationRecord

  belongs_to :scan

  validates_presence_of :name,:language,:version, :raw
end
