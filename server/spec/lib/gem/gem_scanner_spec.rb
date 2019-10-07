# spec/lib/gem/gem_scanner_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_scanner'
require 'fileutils'

RSpec.describe 'GemScanner' do

  it 'should be created and scan correctly' do
    parser = GemParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/Gemfile.lock.test'))
    scanner = GemScanner::new(parser.load_deps)
    expect(scanner.scan.length).to eql(5)
  end
end
