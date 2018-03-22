require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/common/generate_report'
require_relative '../lib/common/generic_version_logic'

class ReportsController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:show]

  api :GET, '/projects/:project_id/scans/:format', 'Generate a Report for this Scan'
  param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
  param :format, ['json','pdf','txt'], :required => true
  def show
    case @project.language
      when 'Ruby'
        @vuln_list = GemScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Java'
        @vuln_list = PomScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Python'
        @vuln_list = PipScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    end
    @vuln_list = GenericVersionLogic::finish_version_logic(Dependency.where(['scan_id = ?', @scan.id]),@vuln_list)
    case params[:id]
      when 'json'
        response = @vuln_list.to_json
      when 'pdf'
        return send_file(GenerateReport::gen_pdf(@project.name, @vuln_list, @project.language), :filename => "report.pdf", :type => "application/pdf")
      when 'txt'
        return send_file(GenerateReport::gen_txt(@project.name, @vuln_list, @project.language), :filename => "report.txt", :type => "application/plain")
      else
        response = ''
    end
    json_response(response, :created)
  end

  def get_project_by_id
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

  def set_project_scan
    begin
      param! :scan_id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end

    begin
      @scan = @project.scans.find(params[:scan_id]) if @project
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

end
