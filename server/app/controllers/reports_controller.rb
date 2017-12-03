require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/gem/gem_report'

class ReportsController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:index, :show, :update, :destroy]



  def index
    json_response(error:'Specify a report type')
  end

  def show
      if @project.language == 'Ruby'
        @vuln_list = GemScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      elsif @project.language == 'Java'
        @vuln_list = PomScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      elsif @project.language == 'Python'
        @vuln_list = PipScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      else
        raise EmptyDependencyException.new('Put an actual error message here')
      end
      vuln_cleanup
      if params[:id] == 'json'
        response = @vuln_list.to_json
      elsif params[:id] == 'pdf'
        doc = GemReport::gen_pdf(@vuln_list,@project.language) #TODO ADD JAVA/MAVEN VERSION PROPERLY!
        return send_file(doc, :filename => "report.pdf", :type => "application/pdf")
      elsif params[:id] == 'txt'
        doc = GemReport::gen_txt(@vuln_list,@project.language)
        return send_file(doc, :filename => "report.txt", :type => "application/text")
      else
      response = ''
    end

    json_response(response, :created)
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
