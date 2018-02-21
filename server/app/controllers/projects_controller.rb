class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = current_user.projects
    json_response(@projects)
  end

  # POST /projects
  def create
    @project = current_user.projects.create!(whitelist)
    json_response(@project, :created)
  end

  # GET /projects/:id
  def show
    json_response(@project)
  end

  # PUT /projects/:id
  def update
    @project.update(whitelist)
    head :no_content
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content
  end

  private

  def whitelist
    params.permit(:name, :language,:description, :active, :timeout)
  end

  def find_project_by_id
    begin
      param! :id, String, required: true, format:  /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end

    begin
      @project = Project.find(params[:id])
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

end
