# app/controllers/reports_controller.rb
require_relative '../lib/pom/pom_scanner'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pip/pip_scanner'
require_relative '../lib/common/generate_report'
require_relative '../lib/common/generic_version_logic'

class ReportsController < ProjectAndScanValidatorController
  # Reports controller /projects/project_id/scans/scan_id/reports/

  api :GET, '/projects/:project_id/scans/:format', 'Generate a Report for this Scan'
  param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
  param :format, %w(json pdf txt html), :required => true
  def show
    get_vuln_list
    handle_report
  end

  def get_vuln_list
    case @project.language
      when 'Ruby'
        @vuln_list = GemScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Java'
        @vuln_list = PomScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Python'
        @vuln_list = PipScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    end
  end

  def handle_report
    case params[:id]
      when 'json'
        response = @vuln_list.to_json
      when 'pdf'
        return send_file(GenerateReport::gen_pdf(@project.name, @vuln_list, @project.language), :filename => MsgConstants::FILENAME_PDF, :type => MsgConstants::MIME_PDF)
      when 'txt'
        return send_file(GenerateReport::gen_txt(@project.name, @vuln_list, @project.language), :filename => MsgConstants::FILENAME_TXT, :type => MsgConstants::MIME_PLAIN)
      when 'html'
        return render html: GenerateReport::gen_html(@project.name, @vuln_list, @project.language).html_safe
      else
        return json_response({message: MsgConstants::UPDATE_TYPE_NOT_SUPPORTED}, :unprocessable_entity)
    end
    json_response(response, :created)
  end

end
