class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :update, :destroy]

  api :GET, '/projects/', 'Projects Get'
  def index
    @projects = current_user.projects
    json_response(@projects)
  end

  api :POST, '/projects/:id', 'Projects Create'
  param :language, String, :required => true
  param :description, String
  param :timeout, Integer
  param :name, String, :required => true
  #param :active, Boolean
  def create
    @project = current_user.projects.create!(whitelist)
    json_response(@project, :created)
  end

  api :GET, '/projects/:id', 'Projects Get'
  param :id, String, :required => true
  def show
    json_response(@project)
  end

  api :PUT, '/projects/:id', 'Projects Update'
  param :id, String, :required => true
  param :language, String
  param :description, String
  param :timeout, Integer
  param :name, String
  #param :active, Boolean
  def update
    @project.update(whitelist)
    head :no_content
  end

  api :DELETE, '/projects/:id', 'Projects Delete'
  param :id, String, :required => true
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
