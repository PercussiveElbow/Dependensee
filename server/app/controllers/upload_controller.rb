require_relative '../lib/gem/gem_parser'
require_relative '../lib/pom/pom_parser'
require_relative '../lib/pip/pip_parser'
require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/common/generic_version_logic'

class UploadController < ApplicationController
  before_action :find_project_by_id,:upload_headers
  before_action only: [:show, :update, :destroy]

  def create
    response = what_language?
    json_response(response, :created)
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

  def what_language?
    if @project.language == 'Ruby'
      handle_ruby
    elsif @project.language == 'Java'
      handle_java
    elsif @project.language == 'Python'
      handle_python
    else
      raise EmptyDependencyException.new('No dependencies found in your POST body.')
    end
  end

  # JAVA
  def handle_java
    deps = pom_decode
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep['groupId']+'.'+dep['artifactId'], version: dep['version'], language: 'java', raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])

    @vuln_list = PomScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    JSON.pretty_generate({type: MsgConstants::POMFILE_UPLOADED, scan_id: @scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

  def pom_decode
    deps = PomParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No jars found in your POST body.') if deps.empty?
    deps
  end


  # RUBY
  def handle_ruby
    deps = gem_decode
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep.name, version: dep.version, language: 'ruby', raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])

    @vuln_list = GemScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    JSON.pretty_generate({type: MsgConstants::GEMFILE_UPLOADED, scan_id: @scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

  def gem_decode
    deps = GemParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No gems found in your POST body.') if deps.empty?
    deps
  end

  # PYTHON
  def handle_python
    deps = pip_decode
    @scan = @project.scans.create!(:source => request.headers['source'], :needs_update => 'no')

    deps.each { |dep| @scan.dependencies.create(name: dep['name'], version: dep['version'], language: 'python', raw: dep) }
    deps =  Dependency.where(['scan_id = ?', @scan.id])
    @vuln_list = PipScanner::new(deps).scan
    @vuln_list = GenericVersionLogic::finish_version_logic(deps,@vuln_list)
    vuln_total
    JSON.pretty_generate({type: MsgConstants::PIPFILE_UPLOADED, scan_id: @scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

  def pip_decode
    deps = PipParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No pip dependencies found in your POST body.') if deps.empty?
    deps
  end

  def vuln_total
    @vuln_total=0
    @vuln_list.each { |k, v| @vuln_total+=v['cves'].length }
  end

end
