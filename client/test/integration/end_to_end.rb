require "test/unit"
require 'net/http'
require 'uri'
require 'json'
require 'open-uri'

class IntegrationTest < Test::Unit::TestCase
 extend Test::Unit::Assertions

	SERVER_URL = 'http://127.0.0.1:3000/api/v1/'
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
		print %x{export DEPENDENSEE_API_KEY=#{@auth_key} && ruby quickclient.rb #{@project_id} }
		File.delete("quickclient.rb")

		# uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/upload')
		# http = Net::HTTP.new(uri.host, uri.port)
		# request = Net::HTTP::Post.new(uri.request_uri)
		# body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/resources/pom.xml')
		# request.body = body.join
		# request['Authorization'] = @auth_key
		# resp = http.request(request)
		# print "Scan completed. Scan id: #{JSON[resp.body]['scan_id']}\n"
  # 		print "Scan completed. Dependencies found: #{JSON[resp.body]['dependencies']}\n"
  # 		assert_equal("1 Vulnerabilities found",JSON[resp.body]['vunerability_count'].to_s)
  # 		print "Scan completed. Vulnerabilities found: #{JSON[resp.body]['vunerability_count']}\n"
		# print "Scan completed. Vulnerabilities: \n"
		# for dependency,vulns in JSON.parse(JSON[resp.body]['vulnerabilities'])
  #       	for cve in vulns['cves']
  #         		print "             Dependency #{dependency} has vulnerability. CVE ID: #{cve['cve']}  Minimum safe version: #{vulns['overall_patch']}\n"
  #       	end
  #     	end
	end

end

IntegrationTest::full

