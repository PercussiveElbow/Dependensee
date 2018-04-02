require 'git'
require 'yaml'
require 'fileutils'

class BaseDB
  GIT_TIMEOUT = 150000

  @log_name = ''

  def initialize(root_location,db_name,log_name,url)
    @log_name = log_name
    root_location  = MsgConstants::BASE_LOC + root_location
    make_dir(root_location,db_name)
    unless File.directory?(@db_location)
      begin
        Git.clone(url, db_name, :path => root_location)
        Logger.new(STDOUT).info("Cloning #{log_name} to: #{@db_location}")
        $git_timestamp = Time.now.to_i
      rescue Exception => _
        abort 'Error cloning '+ @log_name +', exiting.';
      end
    end
  end

  def make_dir(root_location,db_name)
    FileUtils.mkdir_p(root_location) unless Dir.exist?(root_location)
    @db_location=root_location + '/' + db_name + '/'
  end

  def update?
    needs_save = false
    if $git_timestamp.nil? or ((Time.now.to_i - $git_timestamp) > GIT_TIMEOUT)
      Logger.new(STDOUT).info(MsgConstants::UPDATING + @log_name)
      Git.open(@db_location).pull
      $git_timestamp = Time.now.to_i
      needs_save=true
    end
    needs_save
  end

end