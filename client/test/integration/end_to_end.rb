require "test/unit"
require 'net/http'
require 'uri'
require 'json'
require 'open-uri'

class IntegrationTest < Test::Unit::TestCase
 extend Test::Unit::Assertions

	SERVER_URL = 'http://127.0.0.1:3000/api/v1/'
	SERVER_URL_NO_VER = 'http://127.0.0.1:3000/'
	UI_URL = 'http://127.0.0.1:8080/'

	def self.full
		uri = URI.parse(SERVER_URL + '/signup/')
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		val = Random.rand(9999999);
		user = "testuser" + val.to_s
		email = user + "@test" + val.to_s + ".com"
		password = val.to_s
		request.body=URI.encode_www_form({name: user, email: email, password: password, password_confirmation: password })
		print "Creating new user...#{user} #{email}\n"

		resp = http.request(request)
		assert_equal(true,resp.code.to_s == 201.to_s)
		if resp.code.to_s == 201.to_s
		    @auth_key =  JSON[resp.body]['auth_token']
		    print "User created. Auth key: #{@auth_key}\n"
		else
		    raise StandardError.new 'Error when creating user'
		end

		print "Creating new project...\n"
		uri = URI.parse(SERVER_URL + '/projects/')
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		request['Authorization'] = @auth_key
		request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: 'Java', auto_update: false, auto_scan: false })

		resp = http.request(request)
		assert_equal(true,resp.code.to_s == 201.to_s)
		if resp.code.to_s == 201.to_s
		    @project_id =  JSON[resp.body]['id']
		else
		    raise StandardError.new 'Error when creating project'
		end
		print "New project created. Project ID: #{@project_id} \n"


		IO.copy_stream(open(UI_URL + 'static/quickclient.rb'), 'quickclient.rb')
		print %x{export DEPENDENSEE_API_KEY=#{@auth_key} && ruby quickclient.rb #{SERVER_URL_NO_VER} #{@project_id} }
		File.delete("quickclient.rb")
	end

end

IntegrationTest::full

