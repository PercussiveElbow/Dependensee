require_relative '../../models/ruby_cve'
require_relative '../common/db'
require_relative '../../models/java_cve'

class MavenAndPipDB < DB

  def initialize(root_location)
    super(root_location,'maven_pip_db', 'Maven/Pip CVE DB','https://github.com/victims/victims-cve-db.git')
    save_into_db
  end

  def update?
    #save_into_db if super
  end

  def save_into_db
    Dir.glob(@db_location + '/database/java/' + '**/*.{yaml,YAML}') do |file|
      yaml = YAML.load_file(file)
      JavaCve::new(:cve_id => yaml['cve'], date: yaml['date'],desc: yaml['description'], title: yaml['title'],cvss2: yaml['cvss_v2'],references: yaml['references'],affected: yaml['affected']).save! if JavaCve.where(["cve_id = ?", yaml['cve'].to_s]).empty?
    end
    Dir.glob(@db_location + '/database/python/' + '**/*.{yaml,YAML}') do |file|
      yaml = YAML.load_file(file)
      PythonCve::new(:cve_id => yaml['cve'], date: yaml['date'],desc: yaml['description'], title: yaml['title'],cvss2: yaml['cvss_v2'],references: yaml['references'],affected: yaml['affected']).save! if PythonCve.where(["cve_id = ?", yaml['cve'].to_s]).empty?
    end
  end

end