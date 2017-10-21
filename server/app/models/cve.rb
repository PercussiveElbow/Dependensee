class Cve < ActiveRecord::Base

  # validates_presence_of :cve_id
  self.primary_key = :cve_id
  #
  # def id
  #   sync_with_transaction_state
  #   read_attribute(self.class.primary_key)
  # end

end
