require_relative '../lib/gem/gem_parser'
require_relative '../lib/pom/pom_parser'
require_relative '../lib/pip/pip_parser'
require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/common/generic_version_logic'

class UploadController < ApplicationController
  before_action :find_project_by_id,:upload_headers

  api :POST, '/projects/:project_id/upload/', 'Upload a file to load dependencies from'
  def create
    json_response(process_dep_upload, :created)
  end

  def find_project_by_id
    begin
      param! :project_id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end

    begin
      @project = Project.find(params[:project_id])
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

  def upload_headers
    if request.headers['source'].nil? or  request.headers['source'].empty?
      request.headers['source'] = 'API'
    end
  end

  def process_dep_upload
    case @project.language
      when 'Ruby'
        handle_ruby
      when 'Java'
        handle_java
      when 'Python'
        handle_python
      else
        raise EmptyDependencyException.new('No dependencies found in your POST body.')
    end
  end

  # JAVA
  def handle_java
    deps = PomParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No jars found in your POST body.') if deps.empty?
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep['groupId']+'.'+dep['artifactId'], version: dep['version'], raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])

    @vuln_list = PomScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    json_response(MsgConstants::POMFILE_UPLOADED)
  end

  # RUBY
  def handle_ruby
    deps = GemParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No gems found in your POST body.') if deps.empty?
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep.name, version: dep.version, raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])

    @vuln_list = GemScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    json_response(MsgConstants::GEMFILE_UPLOADED)
  end

  # PYTHON
  def handle_python
    deps = PipParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No pip dependencies found in your POST body.') if deps.empty?
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep['name'], version: dep['version'], raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])
    @vuln_list = PipScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    json_response(MsgConstants::PIPFILE_UPLOADED)
  end

  def vuln_total
    @vuln_total=0
    @vuln_list.each { |_, v| @vuln_total+=v['cves'].length }
  end

  def json_response(message)
    JSON.pretty_generate({type: message, scan_id: @scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

end
