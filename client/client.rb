require 'net/http'
require 'uri'
require 'json'

def scan
  if !File.exists?(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
    raise StandardError.new 'No Gemfile found'
  end

  print "Gemfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
  print "Posting Gemfile contents \n"
  uri = URI.parse("http://127.0.0.1:3000/projects/1/upload")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body.join
  request["Authorization"] = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDgxNzI3MDR9.-FU2VlLEeZMh2yzDAFXy2h1gUyV2_CERf-khHkReHPI"
  resp = http.request(request)
  print JSON[resp.body]['message']

end


scan