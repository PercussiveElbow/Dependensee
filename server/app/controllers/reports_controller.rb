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
      overall_version
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
    @vuln_list.each { |k, v| @vuln_total+=v['cves'].length }
    @vuln_list.delete_if { |_, v| v['cves'].empty? }
  end

  def overall_version
    @vuln_list.each do |dep,vh|
      overall_patch = '0.0.0'
      our_ver = vh['cves'][0] if !vh['cves'].empty?
      vh['cves'].each do |cve|

        if(!cve.patched_version.nil?)
          cve.patched_version.each do |patch_ver|
            if(!patch_ver.include? ',' ) #todo fix
              ver = Gem::Version.new(patch_ver.gsub('>', '').gsub(' ','').gsub('=',''))
              if (ver >= Gem::Version.new(overall_patch.gsub('>', '').gsub(' ','').gsub('=','') ))
                overall_patch = patch_ver
              end
            end
          end
        end
      end
      vh['overall_patch'] = overall_patch
    end
  end

end
