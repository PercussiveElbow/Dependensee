require 'net/http'
require 'uri'
require 'json'

# Hard coded for now, these will be changed.
SERVER_URL = 'http://127.0.0.1:3000'
AUTH_KEY = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGE5Y2VhOTEtNDhkNC00YTIyLTkxOTctZGYwZDA3ZjA3YTAzIiwiZXhwIjoxNTE0NTAyMzIyfQ.LZXRVyS3-lKCzgxrPdY9Uw48wkwoWxiYjX3SqpOUJtc'
@project_id = ''

def scan
  if File.exist s?(File.expand_path File.dirname(__FILE__) + '/pom.xml.test')
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
  uri = URI.parse(SERVER_URL + '/projects/' + @project_id + '/upload')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body.join
  request['Authorization'] = AUTH_KEY
  resp = http.request(request)
  output(resp)
end

def output(resp)
  print "Scan completed. Scan id: #{JSON[resp.body]['scan_id']}\n"
  print "Scan completed. Dependencies found: #{JSON[resp.body]['dependencies']}\n"
  print "Scan completed. Vulnerabilities found: #{JSON[resp.body]['vunerability_count']}\n"
  print "Scan completed. Vulnerabilities: \n"
  for dependency,vulns in JSON.parse(JSON[resp.body]['vulnerabilities'])
    for vuln in vulns
      print "Dependency #{dependency} has vulnerability. CVE ID: #{vuln['cve']}\n"
    end
  end
end


scan