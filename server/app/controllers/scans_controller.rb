# app/controllers/dependencies_controller.rb
class ScansController < ApplicationController
  before_action :get_project_by_id
  before_action :set_project_scan, only: [:show, :update, :destroy]

  # GET /projects/:project_id/scans
  def index
    json_response((@project.scans.sort_by &:created_at).reverse)
  end

  # GET /projects/:project_id/scans/:id
  def show
    json_response(@scan)
  end

  # POST /projects/:project_id/scans
  def create
    @scan = @project.scans.create!(scans_params)
    json_response(@scan, :created)
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
    params.permit(:source, :needs_update)
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

  def set_project_scan
    begin
      param! :id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end

    begin
      @scan = @project.scans.find(params[:id]) if @project
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

end