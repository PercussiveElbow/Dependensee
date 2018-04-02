# spec/lib/pom/pom_version_logic_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_version_logic'
require 'net/http'

RSpec.describe PomVersionLogic do

  it 'should return is vuln not 1' do
    expect(PomVersionLogic::is_vuln?('2.0.0', ['<=1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln not 2' do
    expect(PomVersionLogic::is_vuln?('1.0.1', ['<=1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln not 3' do
    expect(PomVersionLogic::is_vuln?('1.1.1', ['<=1.0.0'],[])).to eql(false)
  end

  it 'should return is vuln 1' do
    expect(PomVersionLogic::is_vuln?('0.9.9', ['<=1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln 2' do
    expect(PomVersionLogic::is_vuln?('0.0.9', ['<=1.0.0'],[])).to eql(true)
  end

  it 'should return is vuln 3' do
    expect(PomVersionLogic::is_vuln?('1.0.1', ['>1.0.0'],[])).to eql(true)
  end

  it 'should return less than vuln 1' do
    expect(PomVersionLogic::is_vuln?('0.0.9', ['<1.0.0'],[])).to eql(true)
  end

  it 'should return less than vuln 2' do
    expect(PomVersionLogic::is_vuln?('1.1.1', ['<1.0.0'],[])).to eql(false)
  end

  it 'should query maven correctly ' do
    expect(PomVersionLogic.get_latest_version('org.asynchttpclient.async-http-client')).to match(/^[0-9][0-9.]*$/)
  end

  describe 'it should handle maven error' do
    before do
      allow(Net::HTTP).to receive(:get).and_raise(StandardError.new('Some network error'))
    end
    it 'should rescue if maven query fails' do
      expect(PomVersionLogic.get_latest_version('com.googlecode.json-simple.json-simple')).to eql(MsgConstants::LATEST_VER_ERROR)
    end
  end

end
