require 'prawn'
require 'date'
require 'fileutils'
require_relative '../msg_constants'

class BaseReport
  def self.add_dir_return_filename(reports_dir = MsgConstants::BASE_REPORT)
    FileUtils::mkdir_p(reports_dir) unless Dir.exists?(reports_dir)
    reports_dir + 'Scan_' + DateTime.now.strftime(MsgConstants::TIMESTAMP)  +' ' + SecureRandom.random_number(100000).to_s
  end

end