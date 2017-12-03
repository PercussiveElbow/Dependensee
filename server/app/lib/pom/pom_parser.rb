require_relative '../common/base_parser'
require 'nokogiri'
require 'open-uri'

class PomParser < BaseParser

  def initialize(pomfile)
    super()
    @pomfile = pomfile
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
    Nokogiri::XML(@pomfile).css('dependency').each do  |dep|
      deps.push({'groupId'=>dep.at_css('groupId').content,'artifactId'=>dep.at_css('artifactId').content,'version'=>dep.at_css('version').content})
    end
    deps
  end

end