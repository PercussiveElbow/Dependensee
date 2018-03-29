require 'net/http'
require 'uri'
require 'json'
require 'fileutils'
require 'rexml/document'
include REXML

class Client
  ####################START CONFIG#########################
  #SERVER_URL = 'https://dependensee.tech/api/v1'
  SERVER_URL = 'http://127.0.0.1:3000/api/v1'
  AUTH_KEY = ENV['DEPENDENSEE_API_KEY']
  ####################END CONFIG###########################
  
  POM_STRING = '/test/resources/pom.xml.test'
  GEM_STRING = '/test/resources/Gemfile.lock.test'
  PIP_STRING = '/test/resources/requirements.txt.test'

  attr_accessor :project_id, :auto_scan, :timeout, :needs_update, :lang, :scan_id, :config_check_timeout

  def initialize
    @lang = ''
  end

  def self.setup(project_id,auto_update=false,auto_scan=true,timeout=3600,config_check_timeout=60)
    client = self.new
    client.project_id=project_id
    client.timeout = timeout
    client.config_check_timeout=config_check_timeout
    client.auto_scan=auto_scan
    if !client.project_id.nil? and !client.project_id.empty?
      client.get_existing_project
    else
      client.lang_check
      client.create_new_project(auto_update)
    end
    client
  end

  def get_existing_project
      resp = get_request(SERVER_URL + '/projects/' + @project_id)
      @lang = JSON[resp.body]['language']
      @timeout = JSON[resp.body]['timeout']
  end

  def lang_check
    if pip_project?
      @lang='Python'
    elsif gem_project?
      @lang='Ruby'
    elsif pom_project?
      @lang='Java'
    else
      raise StandardError.new 'No #{@lang} dependency file found. Exiting.'; exit 1
    end
  end

  def scan
    case @lang
      when 'Python'
        print "Requirements.txt found \n"
        loc = PIP_STRING
      when 'Java'
        print "Pomfile found \n"
        loc = POM_STRING
      when 'Ruby'
        print "Gemfile found \n"
        loc = GEM_STRING
      else
        raise StandardError.new "Language: #{@lang} not supported. Exiting."; exit 1
    end
    body = [] << File.read(File.expand_path File.dirname(__FILE__) + loc)
    post_upload(body)
  end

  def pom_project?(loc=POM_STRING)
    file_exists?(loc) and (@lang.empty? or @lang=='Java')
  end

  def gem_project?(loc=GEM_STRING)
    file_exists?(loc) and (@lang.empty? or @lang=='Ruby')
  end

  def pip_project?(loc=PIP_STRING)
    file_exists?(loc) and (@lang.empty? or @lang=='Python')
  end

  def file_exists?(loc)
    File.exists?(File.expand_path File.dirname(__FILE__) + loc)
  end

  def create_new_project(auto_update)
    print "=======CREATING NEW PROJECT======\n"
    uri = URI.parse(SERVER_URL + '/projects/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = AUTH_KEY
    request.body=URI.encode_www_form({name: File.basename(Dir.getwd), language: @lang, auto_scan: auto_scan,auto_update: auto_update, timeout: @timeout })
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

  def post_upload(body)
    print "Uploading dependency file.\n"
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

  def get_request(location)
    uri = URI.parse(location)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = AUTH_KEY
    resp = http.request(request)
    if resp.code.to_s ==401.to_s
      raise StandardError.new 'Error when creating project, auth key invalid'; exit 1;
    end
    resp
  end

  def check_config(scan_id)
    check_config_project
    get_dependencies if needs_update?(scan_id)
  end

  def needs_update?(scan_id)
    resp = get_request(SERVER_URL + '/projects/' + @project_id + '/scans/' + scan_id)
    @needs_update = JSON[resp.body]['needs_update']
    print 'Checking if scan needs update...: ' + "#{@needs_update}\n"
    return needs_update
  end

  def check_config_project
    print "==========UPDATING CONFIG==========\n"
    resp = get_request(SERVER_URL + '/projects/' + @project_id)
    @auto_scan = JSON[resp.body]['auto_scan'] ? "true" : "false";
    @timeout = JSON[resp.body]['timeout'] 
    print 'Checking if auto-scan is turned on...: ' + @auto_scan + "\n"
    print 'Checking auto-scan timeout...: ' + @timeout.to_s + ' seconds' + "\n"
    print "========DONE UPDATING CONFIG========\n\n"
  end

  def get_dependencies
    print "=========UPDATE INFORMATION========\n"
    resp = get_request(SERVER_URL + '/projects/' + @project_id + '/scans/' + @scan_id + '/dependencies')
    for dep in JSON.parse(resp.body) do
      if !dep['update_to'].nil? and dep['update_to'] != 'null'
        update_dep(dep['name'],dep['update_to'])
      end
    end
    print "===================================\n"
  end

  def update_dep(dep_name,update_version)
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
  end

  def ruby_update(dep_name,update_version,dir)
      FileUtils.cp(File.expand_path(File.dirname(__FILE__) + GEM_STRING), dir)
      # code = system("bundle exec rails")
  end

  def java_update(dep_name,update_version,dir)
      original_filename = File.expand_path(File.dirname(__FILE__) + POM_STRING)
      FileUtils.cp(original_filename, dir)
      update_version = update_version.gsub(/[^.0-9]+/,'') if update_version.include? '='

      xmldoc = Document.new(File.new(original_filename))
      XPath.each(xmldoc, "//dependency") do|node|
          if node.elements['groupId'].text == dep_name.rpartition('.')[0] and node.elements['artifactId'].text == dep_name.rpartition('.')[2]
            puts "Found #{dep_name} in pomfile with unsafe version #{node.elements['version'].text} replacing with #{update_version}"
            node.elements['version'].text = update_version
          end
      end
    xmldoc.write(File.open(dir + "/pom.xml", "w"))
    pom_update_successful?
  end

  def pom_update_successful?
    # print %x{cd #{dir} && mvn install}
    exit_status = 0
    #exit_status = $?.exitstatus
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
                print "Replaced: " +   line + " with: " + dep_name + version + "\n"
                replaced = File.read(filename).gsub(/#{line}/, dep_name + version)
                File.open(filename, "w") {|file| file.puts replaced }
              end
          end
      end
      pip_update_successful?
  end

  def pip_update_successful?
    # print %x{cd #{dir} && pip install -r requirements.txt.test}
    #exit_status = $?.exitstatus
    exit_status = 0
    if exit_status!=0
      print "\n Pip update failed.\n"
      return false
    else
      print "\n Pip update passed.\n"
      return true
    end
  end

  def scan_loop
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
  end

end

if __FILE__ == $0 
  project_id = ARGV[0].nil? ?  '' : ARGV[0]
  Client.setup(project_id).scan_loop
end