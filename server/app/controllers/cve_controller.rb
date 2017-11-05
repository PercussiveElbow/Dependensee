class CveController < ApplicationController
  before_action :name_or_cve, only: [:show]
  skip_before_action :auth_req

  # GET /cve/:cve_id
  def show
    json_response(@cve)
  end

  def name_or_cve
    !params[:id][/\p{L}/].nil? ? find_cve_by_name : find_cve_by_id
  end

  def find_cve_by_id
    @cve = RubyCve.where(["cve_id = ?", params[:id]])
    @cve = JavaCve.where(["cve_id = ?", params[:id]]) if @cve.nil? or @cve.empty?
  end

  def find_cve_by_name
    @cve = RubyCve.where(["dependency_name = ?", params[:id]])
    #
    #
    # group_id = params[:id].rpartition('.').first
    # artifact_id = params[:id].rpartition('.').last
    # if @cve.nil?
    #   JavaCve.all.each do |cve|
    #     for affected in cve['affected']
    #       # @cve = cve if affected['groupId'] == group_id and affected['artifactId'] == artifact_id
    #       @cve = cve if affected['groupId'] == group_id
    #     end
    #   end
    # end
    @cve
  end

end
