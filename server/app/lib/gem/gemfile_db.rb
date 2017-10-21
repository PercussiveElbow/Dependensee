require 'git'
require 'yaml'
require 'fileutils'
require_relative '../../models/cve'

class GemfileDB

  GIT_TIMEOUT = 150000

  def initialize(root_location)
    root_location  = '/tmp/dependensee/' + root_location
    FileUtils.mkdir_p(root_location) unless Dir.exist?(root_location)
    @db_location=root_location + '/ruby_cves/'
    if !File.directory?(@db_location)
      begin
        Git.clone('https://github.com/rubysec/ruby-advisory-db.git', 'ruby_cves', :path => root_location)
        print('Cloning Ruby CVE DB to: ' + @db_location + "\n")
        $git_timestamp = Time.now.to_i
      rescue
        abort 'Error cloning Ruby CVE DB, exiting.';
      end
    end
    save_into_db
  end

  def update?
    if $git_timestamp.nil? or ((Time.now.to_i - $git_timestamp) > GIT_TIMEOUT)
      print("\n" + 'Updating Ruby CVE DB..' + "\n")
      Git.open(@db_location).pull
      $git_timestamp = Time.now.to_i
      save_into_db
    else
      print("\nNo need to update Ruby CVE DB\n")
    end
  end

    def save_into_db
      Dir.glob(@db_location + '/gems/' + '**/*.{yml,YML}') do |file|
        yaml = YAML.load_file(file)
        if yaml['cve'].nil?
          #osvdb deal with these later
        else
          Cve::new(:dependency_name => yaml['gem'], :cve_id => yaml['cve'], :date => yaml['date'], :desc => yaml['description'], :cvss2 => yaml['cvss_v2'], :unaffected_versions => yaml['unaffected_versions'].to_a, :patched_versions => yaml['patched_versions'].to_a).save! if Cve.where(["cve_id = ?", yaml['cve'].to_s]).empty?
        end
      end

      cve_list = Cve.where(["dependency_name = ?", 'actionpack'])

      cve_list.each do |cve|
        cve
        # print("\n"
        end
      end
end