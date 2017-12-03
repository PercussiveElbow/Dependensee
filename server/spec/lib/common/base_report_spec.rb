# spec/lib/common/base_report_spec.rb
require 'rails_helper'
require 'fileutils'
require_relative '../../../app/lib/common/base_report'

RSpec.describe 'BaseReport' do

  it 'should create dir correctly when doesnt exist' do
    dir = '/tmp/test/dependensee/reports/'
    FileUtils.rm_r dir if Dir.exist? dir
    BaseReport.add_dir_return_filename(dir)
    expect(Dir.exists? dir).to eql(true)
    FileUtils.rm_r dir
  end

  it 'should handle existing dir correctly' do
    dir = '/tmp/test2/dependensee/reports/'
    FileUtils::mkdir_p dir
    BaseReport.add_dir_return_filename(dir)
    expect(Dir.exists? dir).to eql(true)
    FileUtils.rm_r dir
  end

end