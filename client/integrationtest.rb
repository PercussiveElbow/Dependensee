require "test/unit"
require 'net/http'
require 'uri'
require 'json'

class IntegrationTest < Test::Unit::TestCase
	extend Test::Unit::Assertions

SERVER_URL = 'http://127.0.0.1:3000'

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
		request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: 'Java' })

		resp = http.request(request)
		assert_equal(true,resp.code.to_s == 201.to_s)
		if resp.code.to_s == 201.to_s
		    @project_id =  JSON[resp.body]['id']
		else
		    raise StandardError.new 'Error when creating project'
		end
		print "New project created. Project ID: #{@project_id} \n"

		uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/upload')
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
		request.body = body.join
		request['Authorization'] = @auth_key
		resp = http.request(request)
		print "Scan completed. Scan id: #{JSON[resp.body]['scan_id']}\n"
  		print "Scan completed. Dependencies found: #{JSON[resp.body]['dependencies']}\n"
  		assert_equal("1 Vulnerabilities found",JSON[resp.body]['vunerability_count'].to_s)
  		print "Scan completed. Vulnerabilities found: #{JSON[resp.body]['vunerability_count']}\n"
		print "Scan completed. Vulnerabilities: \n"
		for dependency,vulns in JSON.parse(JSON[resp.body]['vulnerabilities'])
		  for vuln in vulns
		    print "Dependency #{dependency} has vulnerability. CVE ID: #{vuln['cve']}\n"
		  end
		end
	end

end

IntegrationTest::full

