# app/controllers/dependencies_controller.rb
class DependenciesController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id
  before_action :set_project_dependency, only: [:show, :update, :destroy]

  # GET /projects/:project_id/scans/:scan_id/dependencies
  def index
    json_response(@scan.dependencies)
  end

  # GET /projects/:project_id/scans/:scan_id/dependencies/:dependency_id
  def show
    json_response(@dependency)
  end

  # POST /projects/:project_id/scans/
  def create
    @dependency = @scan.dependencies.create!(dependency_params)
    json_response(@dependency, :created)
  end

  # PUT /projects/:project_id/scans/:scan_id/dependencies/:dependency_id
  def update
    @dependency.update(dependency_params)
    head :no_content
  end

  # DELETE /projects/:project_id/scans/:scan_id/dependencies/:dependency_id
  def destroy
    @dependency.destroy
    head :no_content
  end

  private

  def dependency_params
    params.permit(:name, :language, :raw, :version)
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

  def set_project_dependency
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