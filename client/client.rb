require 'net/http'
require 'uri'
require 'json'
require 'fileutils'

# Hard coded for now, these will be changed, shouldn't put api keys in VC but its just dummy accounts whoops
SERVER_URL = 'http://127.0.0.1:3000'
AUTH_KEY = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY2QxZjA5MzYtY2FkZS00NjZjLWIyNDktZDBlOWNiZTVlODQ5IiwiZXhwIjoxNTIwNDM2NjU1fQ.iPolbsrc1OrOAUQ7h2iuZEKuzRNsk0_r9QPMA8A2E5Q'
ARGV[0].nil? ? @project_id = '' : @project_id = ARGV[0]
@auto_scan = false;
@timeout = 3600;
@needs_update = 'no'

def scan
  if File.exists?(File.expand_path File.dirname(__FILE__) + '/requirements.txt.test')
    pip_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
    gem_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
    maven_project
  else
      raise StandardError.new 'No Dependency file found. Exiting.'
  end
end

def gem_project
  print "Gemfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/Gemfile.lock.test')
  post('Ruby',body)
end

def maven_project
  print "Pomfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
  post('Java',body)
end

def pip_project
  print "Pip dependencies found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + '/requirements.txt.test')
  post('Python',body)
end

def create_new_project(language)
  print "=======CREATING NEW PROJECT======\n"
  uri = URI.parse(SERVER_URL + '/projects/')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: language, active: true, timeout: 3600 })

  resp = http.request(request)
  if resp.code.to_s == 201.to_s
    @project_id =  JSON[resp.body]['id']
  else
    raise StandardError.new 'Error when creating project'
  end
  print "Project ID: #{@project_id}\n"
  print "=======DONE PROJECT CREATION======\n\n"
end

def post(language,body)
  create_new_project(language) if(@project_id.nil? or @project_id.empty?)
  print "Attempting to upload dependencies..\n"
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
  print "=========SCAN INFORMATION========\n"
  print "Scan id: #{JSON[resp.body]['scan_id']}\n"
  @scan_id = JSON[resp.body]['scan_id']
  print "Dependencies found: #{JSON[resp.body]['dependencies']}\n"
  print "Vulnerabilities found: #{JSON[resp.body]['vunerability_count']}\n"
  print "Vulnerabilities: \n"
  for dependency,vulns in JSON.parse(JSON[resp.body]['vulnerabilities'])
    for cve in vulns['cves']
      print "             Dependency #{dependency} has vulnerability. CVE ID: #{cve['cve']}  Minimum safe version: #{vulns['overall_patch']}\n"
    end
  end
  print "================================\n\n"
end


def check_config(scan_id)
  print "==========UPDATING CONFIG==========\n"
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/scans/' + scan_id)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)
  @needs_update = JSON[resp.body]['needs_update']
  print 'Checking if scan needs update...: ' + "#{@needs_update}\n"

  uri = URI.parse(SERVER_URL + '/projects/' + @project_id)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)
  @auto_scan = JSON[resp.body]['active'] ? "true" : "false";
  print 'Checking if auto-scan is turned on...: ' + @auto_scan + "\n"
  @timeout = JSON[resp.body]['timeout'] 
  print 'Checking auto-scan timeout...: ' + @timeout.to_s + ' seconds' + "\n"
  print "========DONE UPDATING CONFIG========\n\n"
  needs_update?
end

def needs_update?
  if @needs_update=='any'
      print "Update needed"
  else
    print "No update needed currently\n"
  end
end

def ruby_update
    dir = "backup/#{Time.now.to_i}"
    FileUtils.mkdir_p dir
    FileUtils.cp(File.expand_path(File.dirname(__FILE__) + '/Gemfile.lock.test'), dir)
    code = system("bundle exec rails")
end

def java_update
    dir = "backup/#{Time.now.to_i}"
    FileUtils.mkdir_p dir
    FileUtils.cp(File.expand_path(File.dirname(__FILE__) + '/pom.xml.test'), dir)
end

def python_update
    dir = "backup/#{Time.now.to_i}"
    FileUtils.mkdir_p dir
    FileUtils.cp(File.expand_path(File.dirname(__FILE__) + '/requirements.txt.test'), dir)

end

def get_dependencies
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/scans/' + @scan_id + '/dependencies')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)

  deps = JSON.parse(resp.body)
  for dep in deps do
    if !dep['update_to'].nil? and dep['update_to'] != 'null'
      print "#{dep['name']} update to: #{dep['update_to']}\n"
    end
  end
end

while true
  java_update
  print "=====CLIENT STARTED: Beginning at #{Time.new.inspect}========\n"
  scan
  check_config(@scan_id)
  print "Sleeping for #{@timeout} seconds.\n"
  get_dependencies
  sleep @timeout
end
