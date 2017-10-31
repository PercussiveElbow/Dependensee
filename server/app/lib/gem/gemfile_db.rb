require_relative '../../models/ruby_cve'
require_relative '../common/db'

class GemfileDB < DB

  #override
  def initialize(root_location)
    super(root_location, 'ruby_cve', 'Ruby CVE DB','https://github.com/rubysec/ruby-advisory-db.git')
    save_into_db
  end

  def update?
   save_into_db if super
   end

  def save_into_db
      Dir.glob(@db_location + '/gems/' + '**/*.{yml,YML}') do |file|
        yaml = YAML.load_file(file)
        if yaml['cve'].nil?
          #osvdb deal with these later
        else
          RubyCve::new(:dependency_name => yaml['gem'], :cve_id => yaml['cve'], :date => yaml['date'], :desc => yaml['description'], :cvss2 => yaml['cvss_v2'], :unaffected_versions => yaml['unaffected_versions'].to_a, :patched_versions => yaml['patched_versions'].to_a).save! if RubyCve.where(["cve_id = ?", yaml['cve'].to_s]).empty?
        end
      end
  end

end