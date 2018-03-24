# app/controllers/updates_controller.rb

require_relative '../lib/common/generic_version_logic'
require_relative '../lib/common/update_deps'
require_relative '../lib/msg_constants'

class UpdatesController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id

  def_param_group :project_and_scan do
    param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
    param :scan_id, String,:desc=> 'Scan ID (UUID)', :required => true
  end

  api :POST, '/projects/:project_id/scans/:scan_id/updates/:type', 'Request an Update'
  param_group :project_and_scan
  param :type, ['safe','latest','manual'], :required => true
  def create
    case params[:id]
      when 'latest'
        json_response(UpdateDeps::handle_latest(@project,@scan), :ok)
      when 'safe'
        json_response(UpdateDeps::handle_safe(@project,@scan,nil), :ok)
      when 'manual'
        json_response(UpdateDeps::handle_manual(@scan), :ok)
      else
        json_response({message: MsgConstants::UPDATE_TYPE_NOT_SUPPORTED}, :unprocessable_entity)
    end
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