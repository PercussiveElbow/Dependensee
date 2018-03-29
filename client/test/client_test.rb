require 'test/unit'
require_relative '../client'

class TestClient < Test::Unit::TestCase
	@@previous_project_id = ''

	def setup
		@client = Client.new
		@client.auth_key= ENV['DEPENDENSEE_API_TEST_KEY']
	end

	def create_project
		client = Client.new
		client.auth_key = @client.auth_key
		client.lang='Java'
		client.timeout = 9999
		client.auto_scan = true
		client.auto_update = true
		client.create_new_project
		client.project_id
	end

	def test_pom_project
		assert_equal(false,@client.pom_project?('Gemfile.lock.test'))
		assert_equal(true,@client.pom_project?('/test/resources/pom.xml'))
	end

	def test_pip_project
		assert_equal(false,@client.pip_project?('requirements.txt.test'))
		assert_equal(true,@client.pip_project?('/test/resources/requirements.txt'))
	end

	def test_gem_project
		assert_equal(false,@client.gem_project?('Gemfile.lock.test'))
		assert_equal(true,@client.gem_project?('/test/resources/Gemfile.lock'))
	end

	def test_lang_check
		@client.lang_check
		assert_equal("Python",@client.lang)
	end

	def test_create_new_project
		@client.lang='Java'
		@client.timeout = 9999
		@client.auto_scan = true
		@client.auto_update = true
		@client.create_new_project
		assert_not_nil(@client.project_id)
		@@previous_project_id = @client.project_id
	end

	def test_get_existing_project
		@client.project_id = create_project
		@client.get_existing_project
		assert_equal('Java',@client.lang)
		assert_equal(9999,@client.timeout)
	end

	def test_check_config_project
		@client.project_id = create_project
		@client.check_config_project
		assert_equal(true,@client.auto_scan)
		assert_equal(9999,@client.timeout)
	end

	def test_scan
		@client = Client.setup(@client.auth_key,create_project)
		@client.scan
		assert_not_nil(@client.scan_id)
	end

	def test_needs_update
		@client = Client.setup(@client.auth_key,create_project)
		@client.scan
		assert_equal(true,@client.needs_update?(@client.scan_id))
	end


end