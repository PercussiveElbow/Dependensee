require_relative '../lib/gem/gemfile_parser'
require_relative '../lib/gem/gemfile_db'
require_relative '../lib/gem/gemfile_scanner'

class UploadController < ApplicationController
  before_action :find_project_by_id
  before_action only: [:show, :update, :destroy]


  def create
    specs = gemfile_decode
    $ruby_db.update?
    @vuln_list = GemfileScanner::new(specs).scan_all_gems

    #TODO REPLACE WITH PROPER IMPLEMENTATION
    total=0
    for k,v in @vuln_list do total+=v.length end
    @vuln_list.delete_if { |k, v| v.empty? }

    scan = @project.scans.create!(:source => headers['source'])
    for spec in specs do scan.dependencies.create(name: spec.name, version: spec.version, language: 'ruby', raw: spec) end

    response = JSON.pretty_generate({type: MsgConstants::GEMFILE_UPLOADED, scan_id: scan.id,dependencies:  specs.length.to_s + ' ' +  MsgConstants::DEPENDENCIES_FOUND, vunerability_count: total.to_s  + ' ' + MsgConstants::VULNERABILITIES_FOUND, vulnerabilities:  @vuln_list.to_json })
    json_response(response, :created)
  end

  def find_project_by_id
    begin
      @project = Project.find(params[:project_id])
    rescue
      Raise CustomException::NotFound, MsgConstants::NOT_FOUND
    end
  end


  def upload_headers
    headers.permit(:source)
  end


  def validate

  end

  def what_language?
    # if language == 'ruby' do

    # end
  end

  def gemfile_decode
    specs = GemfileParser::load_from_post(request.raw_post).load_specs
    if specs.empty?
      raise EmptyDependencyException.new('No gems found in your POST body.')
    end
    specs
  end

end
