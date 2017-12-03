# spec/lib/gem/gem_version_logic_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_version_logic'

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
    expect(GemVersionLogic::is_unaffected('4.0.0','>=3.0.0')).to eql(true)
  end

  it 'should test unaffected not' do
    expect(GemVersionLogic::is_unaffected('3.0.0','>=4.0.0')).to eql(false)
  end

  it 'should test unaffected minor' do
    expect(GemVersionLogic::is_unaffected('3.0.1','~>3.0.0')).to eql(true)
  end

  it 'should test unaffected minor not' do
    expect(GemVersionLogic::is_unaffected('4.0.1','~>3.0.0')).to eql(false)
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
    expect(GemVersionLogic::is_unaffected('1.0','<=1.1')).to eql(true)
  end

  it 'should test if it is safe version under 2' do
    expect(GemVersionLogic::is_unaffected('1.0','<1.1')).to eql(true)
  end

  it 'should query rubygems correctly ' do
    puts GemVersionLogic.get_latest_version('activerecord')
  end

end
