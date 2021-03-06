# spec/lib/common/base_db_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/common/base_db'
require 'fileutils'
require 'git'


RSpec.describe BaseDB do

  it 'should be created correctly and update correctly ' do
    root_loc = 'test/git'
    db = BaseDB.new(root_loc,'testdb','testdb','https://github.com/githubtraining/hellogitworld.git') # just clone githubs hello world project
    expect(Dir.exist? '/tmp/dependensee/'+ root_loc).to eql(true)
    db.update?
    $git_timestamp = nil
    db.update?
    FileUtils.rm_r  '/tmp/dependensee/'+root_loc
  end



  describe 'error handling ' do
    before do
      allow(Git).to receive(:clone).and_raise(StandardError.new('Some git thing happened'))
    end

    it 'should return an error if git gives an error' do
      root_loc = 'test/git'
      expect {BaseDB.new(root_loc,'testdb','testdb','https://github.com/githubtraining/hellogitworld.git')}.to raise_error(Exception, 'Error cloning testdb, exiting.')
    end
  end

end