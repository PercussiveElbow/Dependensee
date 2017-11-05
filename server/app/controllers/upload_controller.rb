require_relative '../lib/gem/gem_parser'
require_relative '../lib/pom/pom_parser'
require_relative '../lib/pip/pip_parser'
require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'


class UploadController < ApplicationController
  before_action :find_project_by_id
  before_action only: [:show, :update, :destroy]

  def create
    response = what_language?
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

  def what_language?
    if @project.language == 'ruby'
      handle_ruby
    elsif @project.language == 'java'
      handle_java
    elsif @project.language == 'python'
      handle_python
    else
      raise EmptyDependencyException.new('No dependencies found in your POST body.')
    end
  end


  # JAVA
  def handle_java
    deps = pom_decode
    scan = @project.scans.create!(:source => headers['source'])

    for dep in deps do scan.dependencies.create(name: dep['groupId']+'.'+dep['artifactId'], version: dep['version'], language: 'java', raw: dep) end
    @vuln_list = PomScanner::new(deps).scan
    vuln_cleanup

    JSON.pretty_generate({type: MsgConstants::POMFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

  def pom_decode
    deps = PomParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No jars found in your POST body.') if deps.empty?
    deps
  end


  # RUBY
  def handle_ruby
    deps = gem_decode
    scan = @project.scans.create!(:source => headers['source'])

    for dep in deps do scan.dependencies.create(name: dep.name, version: dep.version, language: 'ruby', raw: dep) end
    @vuln_list = GemfileScanner::new(deps).scan
    vuln_cleanup

    JSON.pretty_generate({type: MsgConstants::GEMFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end

  def gem_decode
    deps = GemfileParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No gems found in your POST body.') if deps.empty?
    deps
  end

  # PYTHON
  def handle_python
    deps = pip_decode
    scan = @project.scans.create!(:source => headers['source'])

    for dep in deps do scan.dependencies.create(name: dep['name'], version: dep['version'], language: 'python', raw: dep) end
    @vuln_list = PipScanner::new(deps).scan
    vuln_cleanup

    JSON.pretty_generate({type: MsgConstants::PIPFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })

  end

  def pip_decode
    deps = PipParser::load_from_post(request.raw_post).load_deps
    raise EmptyDependencyException.new('No pip dependencies found in your POST body.') if deps.empty?
    deps
  end


  # OTHER
  def vuln_cleanup
    @vuln_total=0
    for k,v in @vuln_list do @vuln_total+=v.length end
    @vuln_list.delete_if { |k, v| v.empty? }
  end

end
