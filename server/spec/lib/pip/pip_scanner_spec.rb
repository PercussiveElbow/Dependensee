# spec/lib/pip/pip_scanner_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pip/pip_scanner'
require_relative '../../../app/lib/pip/pip_parser'
require 'fileutils'

RSpec.describe 'PipScanner' do

  it 'should be created and scan correctly' do
    parser = PipParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/requirements.txt.test'))
    scanner = PipScanner::new(parser.load_deps)
    expect(scanner.scan.length).to eql(26)
  end
end