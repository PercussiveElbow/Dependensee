# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :find_project_by_id, only: [:show, :update, :destroy]
  # Projects controller /projects/

  api :GET, '/projects/', 'Get all Projects'
  def index
    @projects = current_user.projects
    json_response(@projects)
  end

  api :POST, '/projects/:id', 'Create a Project'
  param :language, %w(Java Ruby Python), :desc => 'Language' , :required => true
  param :description, String, :desc => 'Description for the project'
  param :timeout, Integer, :desc => 'Timeout between scans (seconds) '
  param :name, String, :desc => 'Name of the project', :required => true
  param :auto_update,  [true, false]
  param :auto_scan,  [true, false]
  def create
    @project = current_user.projects.create!(whitelist)
    json_response(@project, :created)
  end

  api :GET, '/projects/:id', 'Get a Project'
  param :id, String, :desc => 'Project ID (UUID) ', :required => true
  def show
    json_response(@project)
  end

  api :PUT, '/projects/:id', 'Update an existing Project'
  param :id, String, :desc => 'Project ID (UUID) ', :required => true
  param :language, %w(Java Ruby Python), :desc => 'Language' , :required => true
  param :description, String, :desc => 'Description for the project'
  param :timeout, Integer, :desc => 'Timeout between scans (seconds) '
  param :name, String, :desc => 'Name of the project', :required => true
  param :auto_update,  [true, false]
  param :auto_scan,  [true, false]
  def update
    @project.update(whitelist)
    head :no_content
  end

  api :DELETE, '/projects/:id', 'Delete a Project'
  param :id, String, :desc => 'Project ID (UUID) ', :required => true
  def destroy
    @project.destroy
    head :no_content
  end

  private
  def whitelist
    params.permit(:name, :language,:description, :auto_update, :timeout,:auto_scan)
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
