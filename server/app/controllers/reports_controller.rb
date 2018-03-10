require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/gem/gem_report'
require_relative '../lib/common/generic_version_logic'

class ReportsController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:index, :show]

  def index
    json_response(error:'Specify a report type')
  end

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
      when 'pdf' #TODO ADD JAVA/MAVEN VERSION PROPERLY!
        return send_file(GemReport::gen_pdf(@vuln_list,@project.language), :filename => "report.pdf", :type => "application/pdf")
      when 'txt'
        return send_file(GemReport::gen_txt(@vuln_list,@project.language), :filename => "report.txt", :type => "text/plain")
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
