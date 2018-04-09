class RubyCve < ActiveRecord::Base
  validates_presence_of :cve_id
  self.primary_key = :cve_id
  validates_presence_of :dependency_name,:date,:desc
end
