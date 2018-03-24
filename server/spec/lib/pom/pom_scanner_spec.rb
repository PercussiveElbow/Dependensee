# spec/lib/gem/pom_scanner_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_scanner'
require_relative '../../../app/lib/pom/pom_parser'
require 'fileutils'

RSpec.describe 'PomScanner' do

  it 'should be created and scan correctly' do
    parser = PomParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/pom.xml.test'))
    deps = parser.load_deps
    deps_final = []
    deps.each { |dep|
      deps_final.push(Dependency.create(name: dep['groupId']+'.'+dep['artifactId'], version: dep['version'], raw: dep))
    }
    scanner = PomScanner::new(deps_final)
    expect(scanner.scan.length).to eql(1)
  end
end