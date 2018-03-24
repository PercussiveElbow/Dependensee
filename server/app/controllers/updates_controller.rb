# app/controllers/updates_controller.rb

require_relative '../lib/common/generic_version_logic'
require_relative '../lib/gem/gem_scanner'
require_relative '../lib/pom/pom_scanner'
require_relative '../lib/pip/pip_scanner'

class UpdatesController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id

  def create
    case params[:id]
      when 'latest'
        json_response(handle_latest, :ok)
      when 'safe'
        json_response(handle_safe, :ok)
      when 'manual'
        json_response(handle_manual, :ok)
      else
        json_response(response, :unprocessable_entity)
    end
  end


  def handle_manual
    @scan['needs_update'] = 'manual'
    { message: "Scan #{params[:scan_id]} vulnerable dependencies set to manual" }
  end

  def handle_latest
    @vuln_list = get_vulns
    for dep_name, vulns in @vuln_list
      set_update_version(dep_name,get_latest(dep_name))
    end
    { message: "Scan #{params[:scan_id]} vulnerable dependencies set to latest" }
  end

  def handle_safe
    @vuln_list = get_vulns

    for dep_name, vulns in @vuln_list
      set_update_version(dep_name,vulns['overall_patch'])
    end
    { message: "Scan #{params[:scan_id]} vulnerable dependencies set to safe" }
  end

  def get_latest(dep_name)
    case @project.language
      when 'Ruby'
        GemVersionLogic::get_latest_version(dep_name)
      when 'Java'
        PomVersionLogic::get_latest_version(dep_name)
      when 'Python'
        PipVersionLogic::get_latest_version(dep_name)
    end
  end


  def set_update_version(dep_name,update_ver)
    @scan.dependencies.where(name: dep_name)[0].update(update_to: update_ver)
  end

  def get_vulns
    case @project.language
      when 'Ruby'
       GemScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Java'
        PomScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
      when 'Python'
       PipScanner::new(Dependency.where(['scan_id = ?', @scan.id])).scan
    end
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


  def get_scan_by_id
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