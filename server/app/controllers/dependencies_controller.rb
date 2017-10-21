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
    @scan.dependencies.create!(dependency_params)
    json_response(@scan, :created)
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
    params.permit(:name, :language, :raw, :version, :raw)
  end

  def get_project_by_id
    @project = Project.find(params[:project_id])
  end

  def set_project_dependency
    @dependency = @scan.dependencies.find_by!(id: params[:id]) if @scan
  end

  def get_scan_by_id
    @scan = @project.scans.find_by(params[:scan_id])
  end

end