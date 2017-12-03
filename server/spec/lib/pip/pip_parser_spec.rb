# spec/lib/common/pip_parser_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pip/pip_parser'
require 'fileutils'

RSpec.describe 'PipParser' do

  it 'should be created correctly from post' do
    parser = PipParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/requirements.txt.test'))
    expect(parser.load_deps.length).to eql(8)
  end
end

