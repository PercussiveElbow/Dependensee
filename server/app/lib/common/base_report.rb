require 'prawn'
require 'date'
require 'fileutils'
require_relative '../msg_constants'

class BaseReport
  # Base Report class for report utilities
  def self.add_dir_return_filename(reports_dir = MsgConstants::BASE_REPORT)
    FileUtils::mkdir_p(reports_dir) unless Dir.exists?(reports_dir)
    reports_dir + 'Scan_' + DateTime.now.strftime(MsgConstants::TIMESTAMP)  +' ' + SecureRandom.random_number(100000).to_s
  end

  def self.get_cve_info(language, vuln) # Generic method to get CVE info depending on language
    case language
      when 'Java'
        return JavaCve.where(['cve_id = ?', vuln.cve.to_s]).first
      when 'Ruby'
        return RubyCve.where(['cve_id = ?', vuln.cve.to_s]).first
      when 'Python'
        return PythonCve.where(['cve_id = ?', vuln.cve.to_s]).first
    end
  end

  def self.get_title(project) # Get title (projectnmae)
    return project + ' ' +  MsgConstants::TITLE + DateTime.now.strftime('%d/%m/%Y  %H:%M')
  end

end