# app/controllers/dependencies_controller.rb
class DependenciesController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id
  before_action :set_dependency, only: [:show, :update, :destroy]

  def_param_group :project_and_scan do
    param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
    param :scan_id, String,:desc=> 'Scan ID (UUID)', :required => true
  end

  def_param_group :dependency_params do
    param :name, String, :desc=> 'Name of Dependency', :required => true
    param :raw, String, :desc=> 'Raw body of Dependency from file'
    param :version, String, :desc=> 'Version of Dependency', :required => true
    param :update_to, String, :desc=> 'Version this dependency should be updated to'
  end

  api :GET, '/projects/:project_id/scans/:scan_id/dependencies/', 'Get all Dependencies'
  param_group :project_and_scan
  def index
    json_response(@scan.dependencies)
  end

  api :GET, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Get a Dependency'
  param_group :project_and_scan
  param :id, String,:desc=> 'Dependency ID (UUID)', :required => true
  def show
    json_response(@dependency)
  end

  api :POST, '/projects/:project_id/scans/:scan_id/dependencies/', 'Create a Dependency'
  param_group :project_and_scan
  param_group :dependency_params
  def create
    @dependency = @scan.dependencies.create!(dependency_params)
    json_response(@dependency, :created)
  end

  api :PUT, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Update a Dependency'
  param_group :project_and_scan
  param_group :dependency_params
  param :id, String,:desc=> 'Dependency ID (UUID)', :required => true
  def update
    @dependency.update(dependency_params)
    head :no_content
  end

  api :DELETE, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Delete a Dependency'
  param_group :project_and_scan
  param :id, String,:desc=> 'Dependency ID (UUID)', :required => true
  def destroy
    @dependency.destroy
    head :no_content
  end

  private
  def dependency_params
    params.permit(:name, :raw, :version,:update_to)
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

  def set_dependency
    begin
      param! :id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end

    begin
      @dependency = @scan.dependencies.find(params[:id]) if @scan
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