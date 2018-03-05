class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :update, :destroy]

  # def_param_group :projects do
  #   param :id, String, :required => true
  # end

  # GET /projects
  def index
    @projects = current_user.projects
    json_response(@projects)
  end

  # api :POST, '/projects/:id', 'Projects Endpoint'
  # param_group :projects
  # POST /projects
  def create
    @project = current_user.projects.create!(whitelist)
    json_response(@project, :created)
  end

  # api :GET, '/projects/:id', 'Projects Endpoint'
  # param_group :projects
  # GET /projects/:id
  def show
    json_response(@project)
  end
  #
  # api :PUT, '/projects/:id', 'Projects Endpoint'
  # param_group :projects
  # PUT /projects/:id
  def update
    @project.update(whitelist)
    head :no_content
  end

  # api :DELETE, '/projects/:id', 'Projects Endpoint'
  # param_group :projects
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
