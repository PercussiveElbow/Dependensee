require 'git'
require 'yaml'
require 'fileutils'
require_relative '../msg_constants'

class BaseDB
  # Base DB class for extending. Used for cloning git DBs
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

  def make_dir(root_location,db_name) # make directory to clone to if not exists
    FileUtils.mkdir_p(root_location) unless Dir.exist?(root_location)
    @db_location=root_location + '/' + db_name + '/'
  end

  def update? # check if update is needed
    needs_save = false
    if $git_timestamp.nil? or ((Time.now.to_i - $git_timestamp) > MsgConstants::GIT_TIMEOUT)
      Logger.new(STDOUT).info(MsgConstants::UPDATING + @log_name)
      Git.open(@db_location).pull
      $git_timestamp = Time.now.to_i
      needs_save=true
    end
    needs_save
  end

end