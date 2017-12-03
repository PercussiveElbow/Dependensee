# spec/lib/common/base_parser_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/common/base_parser'

RSpec.describe 'BaseParser' do

  it 'should be created and get/set correctly' do
    parser = BaseParser::new
    expect(parser.load_dependencies).to eql(nil)
    expect(parser.load_sources).to eql(nil)
  end

end