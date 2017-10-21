require_relative '../lib/gem/gemfile_parser'
require_relative '../lib/gem/gemfile_db'
require_relative '../lib/gem/gemfile_scanner'

class UploadController < ApplicationController
  before_action :find_project_by_id
  before_action only: [:show, :update, :destroy]


  def create
    specs = GemfileParser::load_from_post(request.raw_post).load_specs
    if specs.empty?
      raise EmptyDependencyException.new('No gems found in your POST body.')
    end

    $db.update?
    @vulnlist = GemfileScanner::new(specs).scan_all_gems(nil)
    response = {message: MsgConstants::GEMFILE_UPLOADED +  specs.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND}
    json_response(response, :created)
  end

  def find_project_by_id
    begin
      @project = Project.find(params[:project_id])
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end


  def validate

  end

end
