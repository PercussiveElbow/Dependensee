# spec/lib/pip/pip_version_logic_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pip/pip_version_logic'
require 'json'
require 'net/http'

RSpec.describe PipVersionLogic do

  it 'should return is vuln not 1' do
    expect(PipVersionLogic::is_vuln?('2.0.0', ['<=1.0.0'],['1.9.9'])).to eql(false)
  end

  it 'should return is vuln not 2' do
    expect(PipVersionLogic::is_vuln?('1.0.1', ['<=1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln not 3' do
    expect(PipVersionLogic::is_vuln?('1.1.1', ['<=1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln 1' do
    expect(PipVersionLogic::is_vuln?('0.9.9', ['<=1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln 2' do
    expect(PipVersionLogic::is_vuln?('0.0.9', ['<=1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln equals' do
    expect(PipVersionLogic::is_vuln?('1.0.0', ['==1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln equals not' do
    expect(PipVersionLogic::is_vuln?('0.9.9', ['==1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln below' do
    expect(PipVersionLogic::is_vuln?('0.9.9', ['<1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln below not' do
    expect(PipVersionLogic::is_vuln?('1.0.0', ['<1.0.0'],[])).to eql(false)
  end

  it 'should query pypi correctly ' do
    expect(PipVersionLogic.get_latest_version('simplejson')).to match(/^[0-9][0-9.]*$/)
  end

  describe 'it should handle pypi error' do
    before do
      allow(Net::HTTP).to receive(:get).and_raise(StandardError.new('Some network error'))
    end
    it 'should rescue if pypi query fails' do
      expect(PipVersionLogic.get_latest_version('selenium')).to eql(MsgConstants::LATEST_VER_ERROR)
    end
  end

end
