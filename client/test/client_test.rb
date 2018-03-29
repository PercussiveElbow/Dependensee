require 'test/unit'
require_relative '../client'


class TestClient < Test::Unit::TestCase

	def test_pom_project
		client = Client.new
		assert_equal(false,client.pom_project?('Gemfile.lock.test'))
		assert_equal(true,client.pom_project?('/test/resources/pom.xml.test'))
	end

	def test_pip_project
		client = Client.new
		assert_equal(false,client.pip_project?('requirements.txt.test'))
		assert_equal(true,client.pip_project?('/test/resources/requirements.txt.test'))
	end

	def test_gem_project
		client = Client.new
		assert_equal(false,client.gem_project?('Gemfile.lock.test'))
		assert_equal(true,client.gem_project?('/test/resources/Gemfile.lock.test'))
	end


end

