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
        print('Cloning ' + @log_name + ' to: ' + @db_location + "\n")
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
      print("\n" + MsgConstants::UPDATING + @log_name +'..' + "\n")
      Git.open(@db_location).pull
      $git_timestamp = Time.now.to_i
      needs_save=true
    else
      # print("\nNo need to update #{@log_name}\n")
    end
    needs_save
  end

end