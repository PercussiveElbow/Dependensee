require 'net/http'
require 'uri'
require 'json'
require 'fileutils'
require 'rexml/document'
include REXML

####################START CONFIG#########################
@config_check_timeout = 60     #60 seconds by defaul
SERVER_URL = 'http://127.0.0.1:3000/api/v1'
#change auth key to env variable
# AUTH_KEY = ENV['DEPENDENSEE_API_KEY']
AUTH_KEY = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZmY3NGQxZjgtOWYyNS00YmQ1LWE3MWUtYTQzZTE2ZjM3YzAxIiwiZXhwIjoxNTIxNzU2NjU2fQ.2rc1nFZsPPeQINEBfSUeRQbVSlRAAWbKZF9bH8a45sM'
####################END CONFIG###########################

ARGV[0].nil? ? @project_id = '' : @project_id = ARGV[0]
@auto_scan = false;
@timeout = 3600;
@needs_update = 'no'
@lang=''

#For easier switching between test 
POM_STRING = '/test/resources/pom.xml.test'
GEM_STRING = '/test/resources/Gemfile.lock.test'
PIP_STRING = '/test/resources/requirements.txt.test'

def scan
  if File.exists?(File.expand_path File.dirname(__FILE__) + PIP_STRING) and (@lang.empty? or @lang=='Python')
    pip_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + GEM_STRING) and (@lang.empty? or @lang=='Ruby')
    gem_project
  elsif File.exists?(File.expand_path File.dirname(__FILE__) + POM_STRING) and (@lang.empty? or @lang=='Java')
    maven_project
  else
    raise StandardError.new 'No #{@lang} Dependency file found. Exiting.'
    exit 1
  end
end

def gem_project
  @lang='Ruby'
  print "Gemfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + GEM_STRING)
  post('Ruby',body)
end

def maven_project
  @lang='Java'
  print "Pomfile found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + POM_STRING)
  post('Java',body)
end

def pip_project
  @lang='Python'
  print "Requirements.txt found \n"
  body = [] << File.read(File.expand_path File.dirname(__FILE__) + PIP_STRING)
  post('Python',body)
end

def create_new_project
  print "=======CREATING NEW PROJECT======\n"
  uri = URI.parse(SERVER_URL + '/projects/')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: @lang, active: true, timeout: 3600 })

  resp = http.request(request)
  if resp.code.to_s == 201.to_s
    @project_id =  JSON[resp.body]['id']
  elsif resp.code.to_s ==401.to_s
    raise StandardError.new 'Error when creating project, auth key invalid'
  else
    raise StandardError.new 'Error when creating project'
  end
  print "Project ID: #{@project_id}\n"
  print "=======DONE PROJECT CREATION======\n\n"
end

def post(language,body)
  create_new_project if(@project_id.nil? or @project_id.empty?)
  print "Attempting to upload dependencies..\n"
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/upload')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body.join
  request['Authorization'] = AUTH_KEY
  os = RbConfig::CONFIG['host_os'] + " #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
  request['Source'] = "Client [#{os}]"
  resp = http.request(request)
  print_scan(resp)
end

def print_scan(resp)
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
    print "Update needed\n"
  else
    print "No update needed currently\n\n"
    get_dependencies
  end
end

def get_dependencies
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/scans/' + @scan_id + '/dependencies')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)

  for dep in JSON.parse(resp.body) do
    if !dep['update_to'].nil? and dep['update_to'] != 'null'
      update(dep['name'],dep['update_to'])
    end
  end
end

def update(dep_name,update_version)
  print "=========UPDATE INFORMATION========\n"
  dir = "backup/#{Time.now.to_i}"
  FileUtils.mkdir_p dir
  case @lang
  when 'Java'
    java_update(dep_name,update_version,dir)
  when 'Ruby'
    ruby_update(dep_name,update_version,dir)
  when 'Python'
    python_update(dep_name,update_version,dir)
  end
  print "===================================\n"
end

def ruby_update(dep_name,update_version,dir)
    FileUtils.cp(File.expand_path(File.dirname(__FILE__) + GEM_STRING), dir)
    # code = system("bundle exec rails")
end

def java_update(dep_name,update_version,dir)
    original_filename = File.expand_path(File.dirname(__FILE__) + POM_STRING)
    FileUtils.cp(original_filename, dir)

    if update_version.include? '='
      update_version = update_version.gsub(/[^.0-9]+/,'')
    else 
      #assume it needs to be bigger,  need to check it's a legit version though.
    end
    xmldoc = Document.new(File.new(original_filename))
    XPath.each(xmldoc, "//dependency") do|node|
        if node.elements['groupId'].text == dep_name.rpartition('.')[0] and node.elements['artifactId'].text == dep_name.rpartition('.')[2]
          puts "Found #{dep_name} in pomfile with unsafe version #{node.elements['version'].text} replacing with #{update_version}"
          node.elements['version'].text = update_version
        end
    end
  xmldoc.write(File.open(dir + "/pom.xml", "w"))
  print %x{cd #{dir} && mvn install}
  exit_status = $?.exitstatus
  if exit_status!=0
    print "\n Java update failed.\n"
    return false
  else
    print "\n Java update passed.\n"
    return true
  end
end

def python_update(dep_name,version,dir)
  FileUtils.cp(File.expand_path(File.dirname(__FILE__) + PIP_STRING), dir)
  filename = "backup/#{Time.now.to_i}/requirements.txt.test"
  File.open(filename, "r") do |file_handle|
        file_handle.each_line do |line|
            if line.include? dep_name
              # line = line.gsub("\n",'')
              print "Replaced line: " +   line + " with: " + dep_name + version + "\n"
              print line + "\n"
              # print text + "\ns"
              replaced = File.read(filename).gsub(/#{line}/, dep_name + version)
              File.open(filename, "w") {|file| file.puts replaced }
            end
        end
    end
  print %x{cd #{dir} && pip install -r requirements.txt.test}
  exit_status = $?.exitstatus
  if exit_status!=0
    print "\n Pip update failed.\n"
    return false
  else
    print "\n Pip update passed.\n"
    return true
  end
end


#On run
if !:project_id.nil? and !@project_id.empty?
    uri = URI.parse(SERVER_URL + '/projects/' + @project_id)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = AUTH_KEY
    resp = http.request(request)
    @lang = JSON[resp.body]['language']
end


while true
  print "=====SCAN STARTED: Beginning at #{Time.new.inspect}========\n"
  scan
  counter = 0
  while counter <= @timeout
    check_config(@scan_id)
    print "\nChecking latest config in 60 seconds. Time til next scan is is #{@timeout-counter}s\n\n"
    sleep @config_check_timeout
    counter += @config_check_timeout
  end
end
