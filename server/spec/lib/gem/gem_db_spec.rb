# spec/lib/gem/gem_db_spec.rb
require 'rails_helper'
require_relative '../../../app/lib/gem/gem_db'

RSpec.describe GemDB do

  describe 'Gem DB Tests' do

    before(:all) do
      @random_no = '/test/' + Random.rand(100).to_s
      @db = GemDB.new(@random_no )
    end

    def common_cve_load(gemname, expected)
      cves = RubyCve.where(['dependency_name = ?', gemname])
      loaded_cves = Array.new
      cves.each{
          |cve| loaded_cves.push(cve.id)
      }
      assert((loaded_cves & expected) == expected)
    end

    after(:all) do
      FileUtils.rm_rf('/tmp/dependensee/' + @random_no)
    end
  end

end