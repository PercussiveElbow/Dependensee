require_relative '../common/base_parser'
require 'bundler'
require 'bundler/lockfile_parser'

class GemParser < BaseParser

  def initialize(lockfile)
    super()
    @lockfile = lockfile
    @dependencies=@lockfile.dependencies
    @sources=@lockfile.sources
  end

  def self.load_from_post(body) # parse lockfile body into lockfile object
    begin
      lockfile = Bundler::LockfileParser.new(body.to_s)
    rescue
      raise(CustomException::DependencyFileError, MsgConstants::DEPENDENCY_FILE_ERROR)
    end
      self.new(lockfile)
  end

  def load_deps # return the dependencies from the lockfile
    specs = @lockfile.specs
    specs.each { |spec|
      spec
      # raise(CustomException::DependencyFileError, MsgConstants::DEPENDENCY_FILE_ERROR) if !dep['groupId'].force_encoding("UTF-8").ascii_only? or dep['groupId'].length > 50 or dep['artifactId'].length > 50
    }
  end

end
