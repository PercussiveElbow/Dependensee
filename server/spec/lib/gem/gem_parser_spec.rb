# spec/lib/common/gem_parser_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_parser'
require 'fileutils'
require 'bundler/lockfile_parser'


RSpec.describe 'GemParser' do

  it 'should be created correctly from post' do
      parser = GemParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/Gemfile.lock.test'))
      expect(parser.load_deps.length).to eql(26)
  end

  describe 'should return error if parsing fails' do
    before do
      allow(Bundler::LockfileParser).to receive(:new).and_raise(StandardError.new('Some lock parser thing happened'))
    end
    it 'should return an error if lockfile parser gives an error' do
      expect {GemParser::load_from_post(File.read File.expand_path(File.dirname(__FILE__) + '../../../resources/Gemfile.lock.test'))}.to raise_error(CustomException::DependencyFileError, MsgConstants::DEPENDENCY_FILE_ERROR)
    end
  end

end