require 'prawn'
require 'date'
require_relative '../msg_constants'


class Report
  def self.add_dir_return_filename(reports_dir = '/tmp/dependensee/reports/')
    reports_dir = '/tmp/dependensee/reports/'
    unless Dir.exists?(reports_dir)
      Dir.mkdir(reports_dir)
    end
    reports_dir + 'Scan_' + DateTime.now.strftime(MsgConstants::TIMESTAMP)
  end

end