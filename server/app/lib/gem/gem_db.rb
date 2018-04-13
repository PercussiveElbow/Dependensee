require_relative '../../models/ruby_cve'
require_relative '../common/base_db'

class GemDB < BaseDB

  #override
  def initialize(root_location)
    super(root_location, MsgConstants::GEM_DB_LOC , MsgConstants::GEM_DB_NAME,MsgConstants::GEM_DB_GIT_URL)
    save_into_db
  end

  def update?
   save_into_db if super
  end

  def save_into_db # save the CVES to DB
      Dir.glob(@db_location + '/gems/' + '**/*.{yml,YML}') do |file|
        yaml = YAML.load_file(file)
        if yaml['cve'].nil?
          # OSVDB, so no need to add
        else
          RubyCve::new(:dependency_name => yaml['gem'], :cve_id => yaml['cve'], :date => yaml['date'], :desc => yaml['description'], :cvss2 => yaml['cvss_v2'], :unaffected_versions => yaml['unaffected_versions'].to_a, :patched_versions => yaml['patched_versions'].to_a).save! if RubyCve.where(['cve_id = ?', yaml['cve'].to_s]).empty?
        end
      end
  end

end