require 'prawn'
require 'date'
require 'fileutils'
require_relative '../msg_constants'


class BaseReport
  def self.add_dir_return_filename(reports_dir = '/tmp/dependensee/reports/')
    FileUtils::mkdir_p(reports_dir) unless Dir.exists?(reports_dir)
    reports_dir + 'Scan_' + DateTime.now.strftime(MsgConstants::TIMESTAMP)
  end

end