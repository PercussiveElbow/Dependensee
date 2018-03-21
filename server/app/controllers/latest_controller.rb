require_relative '../lib/gem/gem_version_logic'
require_relative '../lib/pom/pom_version_logic'
require_relative '../lib/pip/pip_version_logic'


class LatestController < ApplicationController
  before_action :get_project_by_id,:set_project_scan
  before_action :set_project_dependency,  only: [:show]

  def_param_group :project_and_scan do
    param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
    param :scan_id, String,:desc=> 'Scan ID (UUID)', :required => true
  end

  api :GET, '/projects/:project_id/scans/:scan_id/dependencies/:id/latest', 'Get the latest version of the Dependency'
  param_group :project_and_scan
  param :id, String,:desc=> 'Dependency ID (UUID)', :required => true
  def show
    if @project.language == 'Ruby'
      latest_ver = GemVersionLogic::get_latest_version(@dependency.name)
    elsif @project.language == 'Java'
      latest_ver = PomVersionLogic::get_latest_version(@dependency.name)
    elsif @project.language == 'Python'
      latest_ver = PipVersionLogic::get_latest_version(@dependency.name)
    end
    response = JSON.pretty_generate({version: latest_ver.to_s })
    json_response(response, :created)
  end

  def get_project_by_id
    begin
      param! :project_id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end
    @project = Project.find(params[:project_id])
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

  def set_project_dependency
    begin
      param! :dependency_id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end
    @dependency = @scan.dependencies.find(params[:dependency_id]) if @scan
  end

end
