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

  def parse_deps # Parse the dependencies found in pomfile body
    deps = Array.new
    Nokogiri::XML(@pomfile).css('dependency').each do  |dep|
      deps.push({'groupId'=>dep.at_css('groupId').content,'artifactId'=>dep.at_css('artifactId').content,'version'=>dep.at_css('version').content})
    end

    deps.each { |dep|
      dep['groupId'] = dep['groupId'].downcase
      dep['artifactId'] = dep['artifactId'].downcase
      raise(CustomException::DependencyFileError, MsgConstants::DEPENDENCY_FILE_ERROR) if !dep['groupId'].force_encoding("UTF-8").ascii_only? or dep['groupId'].length > 50 or dep['artifactId'].length > 50
    }
    deps
  end

end