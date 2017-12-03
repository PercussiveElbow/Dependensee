# spec/lib/common/gem_parser_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_parser'
require 'fileutils'

RSpec.describe 'GemParser' do

  it 'should be created correctly from post' do
      parser = GemParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/Gemfile.lock.test'))
      expect(parser.load_deps.length).to eql(26)
  end
end