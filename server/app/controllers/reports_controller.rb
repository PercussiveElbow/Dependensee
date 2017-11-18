require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'

class ReportsController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:index, :show, :update, :destroy]



  def index
    return 'broke'
  end



  def show
    response = what_language?
    json_response(response, :created)

  end

  def what_language?
    print params[:id]
    @project
    if @project.language == 'Ruby'
      return handle_ruby
    elsif @project.language == 'Java'
      return handle_java
    elsif @project.language == 'Python'
      return handle_python
    else
      raise EmptyDependencyException.new('Put an actual error message here')
    end
  end

  # JAVA
  def handle_java
    @vuln_list = PomScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    vuln_cleanup
    JSON.pretty_generate({ vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end


  # RUBY
  def handle_ruby
    @vuln_list = GemfileScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    vuln_cleanup
    JSON.pretty_generate({type: MsgConstants::GEMFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
   end



  # PYTHON
  def handle_python
    @vuln_list = PipScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    vuln_cleanup
    JSON.pretty_generate({type: MsgConstants::PIPFILE_UPLOADED, scan_id: scan.id,dependencies:  deps.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: @vuln_total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
  end



  def get_project_by_id
    @project = Project.find(params[:project_id])
  end

  def set_project_scan
    begin
      @scan = @project.scans.find(params[:scan_id]) if @project
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

  # OTHER
  def vuln_cleanup
    @vuln_total=0
    @vuln_list.each { |k, v| @vuln_total+=v.length }
    @vuln_list.delete_if { |_, v| v.empty? }
  end

end
