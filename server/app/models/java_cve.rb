class JavaCve <  ActiveRecord::Base
  serialize :affected, Array
  serialize :references, Array

  validates_presence_of :cve_id

end
