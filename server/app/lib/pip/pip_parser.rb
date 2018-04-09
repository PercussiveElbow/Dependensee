require_relative '../common/base_parser'
require 'nokogiri'
require 'open-uri'

class PipParser < BaseParser

  def initialize(pip_file)
    super()
    @pip_file = pip_file
    @dependencies=parse_deps
  end

  def self.load_from_post(body)
    self.new(body)
  end

  def load_deps
    @dependencies
  end

  def parse_deps # Parse the dependencies found in the requirements.txt file body
    deps = Array.new
    @pip_file.each_line do |line|
      line = line.gsub("\n",'')
      name = line.gsub(/[^a-z\-]/i,'')
      version = line.gsub(/[^0-9=>.]/i,'')
      deps.push({'name'=>name,'version'=>version,'raw'=>line})
    end
    deps
  end

end