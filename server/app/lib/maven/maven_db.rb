require_relative '../../models/ruby_cve'
require_relative '../common/db'

class MavenAndPipDB < DB

  def initialize(root_location)
    super(root_location,'maven_pip_db', 'Maven/Pip CVE DB','https://github.com/victims/victims-cve-db.git')
    # save_into_db
  end

  def update?
    #save_into_db if super
  end

  # def save_into_db

  # end
  
end