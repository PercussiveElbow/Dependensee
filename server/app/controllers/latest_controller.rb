require_relative '../lib/gem/gem_version_logic'


class LatestController < ApplicationController
  before_action :get_project_by_id,:set_project_scan
  before_action :set_project_dependency,  only: [:show]

  def show
    if @project.language == 'Ruby'
      latest_ver = GemVersionLogic::get_latest_version(@dependency.name)
    elsif @project.language == 'Java'
      latest_ver = PomVersionLogic::get_latest_version(@dependency.name)
    elsif @project.language == 'Python'
      latest_ver = PipVersionLogic::get_latest_version(@dependency.name)
    else
      raise EmptyDependencyException.new('Put an actual error message here')
    end
    response = JSON.pretty_generate({version: latest_ver.to_s })
    json_response(response, :created)
  end

  def get_project_by_id
    @project = Project.find(params[:project_id])
  end

  def set_project_scan
    begin
      @scan = @project.scans.find(params[:scan_id]) if @project
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end

  def set_project_dependency
    @dependency = @scan.dependencies.find(params[:dependency_id]) if @scan
  end

end
