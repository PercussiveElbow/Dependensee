require_relative '../common/base_parser'
require 'nokogiri'
require 'open-uri'

class PipParser < BaseParser

  def initialize(pipfile)
    super()
    @pipfile = pipfile
    @dependencies=parse_deps
  end

  def self.load_from_post(body)
    self.new(body)
  end

  def load_deps
    @dependencies
  end

  def parse_deps
    deps = Array.new
    @pipfile.each_line do |line|
      line = line.gsub("\n",'')
      name = line.gsub(/[^a-z\-]/i,'')
      version = line.gsub(/[^0-9=>.]/i,'')
      deps.push({'name'=>name,'version'=>version,'raw'=>line})
    end
    deps
  end

end