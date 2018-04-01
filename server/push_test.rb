require 'net/http'
require 'uri'
require 'json'

# Just a simple push test to check production deployment passed OK

PROD_URL = "https://dependensee.tech/"
PROD_URL_UI = "https://ui.dependensee.tech/"
puts "BEGINNING PUSH TEST"
puts "Check server and UI both respond 200.."
prod_uri = URI.parse(PROD_URL)
http = Net::HTTP.new(prod_uri.host, prod_uri.port)
http.use_ssl=true
request = Net::HTTP::Get.new(prod_uri.request_uri)
resp = http.request(request)
puts "Resp code (server) #{resp.code}"
if resp.code != '200'
	raise "Request failed"
end

ui_uri = URI.parse(PROD_URL_UI)
ui_http = Net::HTTP.new(ui_uri.host, ui_uri.port)
ui_http.use_ssl=true
request = Net::HTTP::Get.new(ui_uri.request_uri)
resp = ui_http.request(request)
puts "Resp code (UI) #{resp.code}"
if resp.code != '200'
	raise "Request failed"
end

puts "Checking docs endpoint"
request = Net::HTTP::Get.new("/docs")
resp = http.request(request)
puts "Resp code (Server (DOCS ENDPOINT)) #{resp.code}"
if resp.code != '200'
	raise "Request failed"
end


puts "Checking cve endpoint"
request = Net::HTTP::Get.new("/api/v1/cve/2017-14063")
resp = http.request(request)
puts "Resp code (Server (CVE ENDPOINT)) #{resp.code}"
if resp.code != '200'
	raise "Request failed"
end

puts "Checking client is avaliable to download"
request = Net::HTTP::Get.new("/static/quickclient.rb")
resp = ui_http.request(request)
puts "Resp code (UI (Client download)) #{resp.code}"
if resp.code != '200'
	raise "Request failed"
end

puts "Setting up user account"
request = Net::HTTP::Post.new("/api/v1/signup")
name = rand(1000..10000000)
email = "pushtestemail" + rand(1..10000000).to_s + "@pushtest.com"
password = "pushtestpassword" + rand(1..10000000).to_s
request.body=URI.encode_www_form({name: name, email: email,password: password,password_confirmation:password })
resp = http.request(request)
puts "Resp code (Server (Setting up user account)) #{resp.code}"
if resp.code != '201'
	raise "Request failed"
end
auth_token = JSON.parse(resp.body)['auth_token']