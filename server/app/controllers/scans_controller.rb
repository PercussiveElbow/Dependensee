# app/controllers/dependencies_controller.rb
class ScansController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:show, :update, :destroy]

  # GET /projects/:project_id/scans
  def index
    json_response(@project.scans)
  end

  # GET /projects/:project_id/scans/:id
  def show
    json_response(@scan)
  end

  # POST /projects/:project_id/scans
  def create
    @project.scans.create!(scans_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/scans/:id
  def update
    @scan.update(scans_params)
    head :no_content
  end

  # DELETE /projects/:project_id/scans/:id
  def destroy
    @scan.destroy
    head :no_content
  end

  private

  def scans_params
    params.permit(:source)
  end

  def get_project_by_id
    @project = Project.find(params[:project_id])
  end

  def set_project_scan
    begin
      @scan = @project.scans.find(id: params[:id]) if @project
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

end