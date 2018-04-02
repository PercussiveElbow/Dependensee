# spec/lib/gem/gem_version_logic_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_version_logic'
require 'rss'

RSpec.describe GemVersionLogic do

  it 'should return above patched version' do
    expect(GemVersionLogic::is_above_patched_ver('2.0.0', '>=1.0.0')).to eql(true)
  end

  it 'should return above patched version same versions' do
    expect(GemVersionLogic::is_above_patched_ver('1.0.0', '>=1.0.0')).to eql(true)
  end

  it 'should return not above patched version' do
    expect(GemVersionLogic::is_above_patched_ver('1.0.0', '>=2.0.0')).to eql(false)
  end

  it 'should return above patched version minor' do
    expect(GemVersionLogic::is_above_patched_ver('1.0.1', '~>1.0.0')).to eql(true)
  end

  it 'should return above patched version minor same' do
    expect(GemVersionLogic::is_above_patched_ver('1.0.0', '~>1.0.0')).to eql(true)
  end

  it 'should return not above patched minor version' do
    expect(GemVersionLogic::is_above_patched_ver('1.0.0', '~>1.0.1')).to eql(false)
  end

  it 'should return not above patched minor version 2' do
    expect(GemVersionLogic::is_above_patched_ver('1.1.0', '~>1.0.0')).to eql(false)
  end

  it 'should test unaffected' do
    expect(GemVersionLogic::unaffected?('4.0.0','>=3.0.0')).to eql(true)
  end

  it 'should test unaffected not' do
    expect(GemVersionLogic::unaffected?('3.0.0','>=4.0.0')).to eql(false)
  end

  it 'should test unaffected minor' do
    expect(GemVersionLogic::unaffected?('3.0.1','~>3.0.0')).to eql(true)
  end

  it 'should test unaffected minor not' do
    expect(GemVersionLogic::unaffected?('4.0.1','~>3.0.0')).to eql(false)
  end

  it 'should test if is within minor version' do
    expect(GemVersionLogic::is_within_minor_ver('3.2.0','3.2.1')).to eql(true)
  end

  it 'should test if is within minor version not' do
    expect(GemVersionLogic::is_within_minor_ver('4.2.0','3.2.1')).to eql(false)
  end

  it 'should test if is within minor version same' do
    expect(GemVersionLogic::is_within_minor_ver('3.2.1','3.2.1')).to eql(true)
  end

  it 'should test if it is safe version under' do
    expect(GemVersionLogic::unaffected?('1.0','<=1.1')).to eql(true)
  end

  it 'should test if it is safe version under 2' do
    expect(GemVersionLogic::unaffected?('1.0','<1.1')).to eql(true)
  end

  it 'should query rubygems correctly ' do
    expect(GemVersionLogic::get_latest_version('nokogiri')).not_to eql(nil)
    expect(GemVersionLogic::get_latest_version('nokogiri')).not_to eql('Latest version unavailable')
  end

  describe 'it should handle rubygems error' do
    before do
      allow(RSS::Parser).to receive(:parse).and_raise(StandardError.new('Some rss error'))
    end

    it 'should rescue if rubygems query fails' do
      expect(GemVersionLogic.get_latest_version('activerecord')).to eql(MsgConstants::LATEST_VER_ERROR)
    end
  end

  it 'should return true if contains a comma and is unaffected' do
    expect(GemVersionLogic::unaffected?('1.0','<1.1,>=5.0.0')).to eql(true)
  end

  it 'should return false if contains a comma and is affected' do
    expect(GemVersionLogic::unaffected?('2.0','<1.1,>=5.0.0')).to eql(false)
  end

  it 'should return false if just greater than' do
    expect(GemVersionLogic::is_above_patched_ver('1.0','>1.1.1')).to eql(false)
  end

end
