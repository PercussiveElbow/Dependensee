require_relative '../common/base_parser'
require 'bundler'
require 'bundler/lockfile_parser'

class GemfileParser < BaseParser

  def initialize(lockfile)
    super()
    @lockfile = lockfile
    @dependencies=@lockfile.dependencies
    @sources=@lockfile.sources
  end

  def self.load_from_post(body)
    self.new(Bundler::LockfileParser.new(body.to_s))
  end

  def load_deps
    @lockfile.specs
  end

end
