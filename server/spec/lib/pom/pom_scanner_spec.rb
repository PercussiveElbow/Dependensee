# spec/lib/gem/pom_scanner_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_scanner'
require 'fileutils'

RSpec.describe 'PomScanner' do

  it 'should be created and scan correctly' do
    parser = PomParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/pom.xml.test'))
    scanner = PomScanner::new(parser.load_deps)
    expect(scanner.scan.length).to eql(26)
  end
end