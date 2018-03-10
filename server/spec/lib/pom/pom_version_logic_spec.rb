# spec/lib/pom/pom_version_logic_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_version_logic'

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

  it 'should return less than vuln 1' do
    expect(PomVersionLogic::is_vuln?('0.0.9', ['<1.0.0'],[])).to eql(true)
  end

  it 'should return less than vuln 2' do
    expect(PomVersionLogic::is_vuln?('1.1.1', ['<1.0.0'],[])).to eql(false)
  end

  it 'should query maven correctly ' do
    expect(PomVersionLogic.get_latest_version('org.asynchttpclient.async-http-client')).to match(/^[0-9][0-9.]*$/)
  end

end
