require 'net/http'
require 'uri'
require 'json'

# Hard coded for now, these will be changed, shouldn't put api keys in VC but its just dummy accounts whoops/home/adam/RubymineProjects/dependensee/client/client.rb
TIMEOUT = 360
SERVER_URL = 'http://127.0.0.1:3000'
AUTH_KEY = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZjA0MjA0MmYtYWMyMC00ODQ3LTkwMmQtMjM1OTA2OGEwNGY3IiwiZXhwIjoxNTE4NzI2NjE5fQ._PdOjIlxCDijn59tdZXetgtGkXU29tq8qhj_N_EmZH0'
ARGV[0].nil? ? @project_id = '' : @project_id = ARGV[0]
#print "Auth key #{ENV['depAPIKey']}\n"

def scan
  if File.exists?(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
    maven_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
    gem_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + '/requirements.txt.test')
    pip_project
  else
      raise StandardError.new 'No Dependency file found. Exiting.'
  end
end

def gem_project
  print "Gemfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
  print "Posting Gemfile contents \n"
  post('Ruby',body)
end

def maven_project
  print "Pomfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
  print "Posting Pomfile contents \n"
  post('Java',body)
end

def pip_project
  print "Pip dependencies found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/requirements.txt.test')
  print "Posting Pip dependencies contents \n"
  post('Python',body)
end

def create_new_project(language)
  print "Creating new project...\n"
  uri = URI.parse(SERVER_URL + '/projects/')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: language })

  resp = http.request(request)
  if resp.code.to_s == 201.to_s
    @project_id =  JSON[resp.body]['id']
  else
    raise StandardError.new 'Error when creating project'
  end
  print "New project created. Project ID: #{@project_id} \n"
end

def post(language,body)
  create_new_project(language) if(@project_id.nil? or @project_id.empty?)
  print "Attempting to upload dependencies and scan..\n"
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/upload')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body.join
  request['Authorization'] = AUTH_KEY
  os = RbConfig::CONFIG['host_os'] + " #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
  request['Source'] = "Client [#{os}]"
  resp = http.request(request)
  output(resp)
end

def output(resp)
  print "Scan completed. Scan id: #{JSON[resp.body]['scan_id']}\n"
  @scan_id = JSON[resp.body]['scan_id']
  print "Scan completed. Dependencies found: #{JSON[resp.body]['dependencies']}\n"
  print "Scan completed. Vulnerabilities found: #{JSON[resp.body]['vunerability_count']}\n"
  print "Scan completed. Vulnerabilities: \n"
  for dependency,vulns in JSON.parse(JSON[resp.body]['vulnerabilities'])
    for vuln in vulns
      print "Dependency #{dependency} has vulnerability. CVE ID: #{vuln['cve']}\n"
    end
  end
end


def check_update(scan_id)
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/scans/' +scan_id)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)
  print 'Checking if scan needs update...' + JSON[resp.body]['needs_update']
end


def ruby_update
    code = system("bundle exec rails")
end

while true
  print "Beginning scan at #{Time.new.inspect}\n"
  scan
  print "Sleeping for #{TIMEOUT} seconds.\n"
  check_update(@scan_id)
  sleep TIMEOUT
end