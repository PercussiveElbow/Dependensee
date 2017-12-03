# spec/lib/gem/gem_db_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/pom/pom_db'

RSpec.describe MavenAndPipDB do

  describe 'Pom DB Tests' do

    before(:all) do
      @random_no = '/test/' + Random.rand(100).to_s
      @db = MavenAndPipDB.new(@random_no )
    end

    def common_cve_load(pomname, expected)
      cves = JavaCve.where(['dependency_name = ?', pomname])
      loaded_cves = Array.new
      cves.each{
          |cve| loaded_cves.push(cve.id)
      }
      assert((loaded_cves & expected) == expected)
    end

    #TODO ADD CATCH FOR OSVDB STUFF ALREADY
    it 'should return correct CVE values for rack' do
      common_cve_load('rack',['2013-0184', '2013-0262','2011-5036','2012-6109','2013-0183','2013-0263','2015-3225'])
    end

    it 'should return correct CVE values for http' do
      common_cve_load('http',['2015-1828'])
    end

    it 'should return correct CVE values for activemodel' do
      common_cve_load('activemodel',['2016-0753'])
    end

    it 'should not load non existing' do
      expect(RubyCve.where(['dependency_name = ?', 'ewigjreaiojoirge']).empty?).to eql(true)
    end

    after(:all) do
      FileUtils.rm_rf('/tmp/dependensee/' + @random_no)
    end
  end

end


# def test_secondary_db_doesnt_break
#   @db.load_cves_for_gem('rack')
#   GemDB.new( @random_no ).load_cves_for_gem('rack')
# end

# after(:all) do
#   FileUtils.rm_rf('/tmp/dependensee/' + @random_no)
# end