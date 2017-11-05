require_relative '../lib/gem/gemfile_parser'
require_relative '../lib/maven/pom_parser'
require_relative '../lib/maven/pom_scanner'
require_relative '../lib/gem/gemfile_db'
require_relative '../lib/gem/gemfile_scanner'

class UploadController < ApplicationController
  before_action :find_project_by_id
  before_action only: [:show, :update, :destroy]

  def create
    response = handle_java
    json_response(response, :created)
  end

  def find_project_by_id
    begin
      @project = Project.find(params[:project_id])
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end


  def upload_headers
    headers.permit(:source)
  end

  # def validate
  #
  # end

  def what_language?
    language = 'java'
    if language.equal('ruby')
      return handle_ruby
    elsif language.equal('java')
      return handle_java
    else
      return 'No deps found'
    end

  end

  def gemfile_decode
    specs = GemfileParser::load_from_post(request.raw_post).load_specs
    if specs.empty?
      raise EmptyDependencyException.new('No gems found in your POST body.')
    end
    specs
  end


  def pomfile_decode
    deps = PomParser::load_from_post(request.raw_post).load_deps
  end


  def handle_java
    deps = pomfile_decode
    scan = @project.scans.create!(:source => headers['source'])
    for dep in deps do scan.dependencies.create(name: dep['groupId']+'.'+dep['artifactId'], version: dep['version'], language: 'java', raw: dep) end
    @vuln_list = PomScanner::new(deps).scan_all_deps

    #TODO REPLACE WITH PROPER IMPLEMENTATION
    total=0
    for k,v in @vuln_list do total+=v.length end
    @vuln_list.delete_if { |k, v| v.empty? }
    JSON.pretty_generate({type: MsgConstants::POMFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end


  def handle_ruby
    deps = gemfile_decode
    $ruby_db.update?
    @vuln_list = GemfileScanner::new(deps).scan_all_deps

    #TODO REPLACE WITH PROPER IMPLEMENTATION
    total=0
    for k,v in @vuln_list do total+=v.length end
    @vuln_list.delete_if { |k, v| v.empty? }

    scan = @project.scans.create!(:source => headers['source'])
    for dep in deps do scan.dependencies.create(name: dep.name, version: dep.version, language: 'ruby', raw: dep) end
    JSON.pretty_generate({type: MsgConstants::GEMFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

end
