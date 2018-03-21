# app/controllers/dependencies_controller.rb
class DependenciesController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id
  before_action :set_dependency, only: [:show, :update, :destroy]

  def_param_group :project_and_scan do
    param :project_id, String, :required => true
    param :scan_id, String, :required => true
  end

  def_param_group :dependency_params do
    param :name, String
    param :raw, String
    param :version, String
  end

  api :GET, '/projects/:project_id/scans/:scan_id/dependencies/', 'Dependencies Get'
  param_group :project_and_scan
  def index
    json_response(@scan.dependencies)
  end

  api :GET, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Dependencies Get'
  param_group :project_and_scan
  param :id, String
  def show
    json_response(@dependency)
  end

  api :POST, '/projects/:project_id/scans/:scan_id/dependencies/', 'Dependencies Post'
  param_group :project_and_scan
  param_group :dependency_params
  def create
    @dependency = @scan.dependencies.create!(dependency_params)
    json_response(@dependency, :created)
  end

  api :PUT, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Dependencies Update'
  param_group :project_and_scan
  param_group :dependency_params
  param :id, String, :required =>true
  def update
    @dependency.update(dependency_params)
    head :no_content
  end

  api :DELETE, '/projects/:project_id/scans/:scan_id/dependencies/:id', 'Dependencies Delete'
  param_group :project_and_scan
  param :id, String, :required => true
  def destroy
    @dependency.destroy
    head :no_content
  end

  private

  def dependency_params
    params.permit(:name, :raw, :version)
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