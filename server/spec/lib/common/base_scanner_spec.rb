# spec/lib/common/scanner_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/common/base_scanner'
require 'fileutils'

RSpec.describe 'Scanner' do

  it 'should be created correctly' do
      arr = [1,2,3]
      scanner = BaseScanner::new(arr)
      instance_get = scanner.instance_variable_get(:@deps)
      expect(arr).to eql(instance_get)
  end
end