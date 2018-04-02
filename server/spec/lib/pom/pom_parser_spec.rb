# spec/lib/common/pom_parser_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_parser'
require 'fileutils'

RSpec.describe 'PomParser' do

  it 'should be created correctly from post' do
    parser = PomParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/pom.xml.test'))
    expect(parser.load_deps.length).to eql(7)
  end
end

