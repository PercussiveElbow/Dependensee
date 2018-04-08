# app/controllers/project_and_scan_validator_controller.rb
class ProjectAndScanValidatorController < ApplicationController
  before_action :get_project_by_id,:get_scan_by_id
  # Generic class to DRY repetitive logic for project+scans dependent controlelrs

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
