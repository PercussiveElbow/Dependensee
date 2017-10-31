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
  end

  def find_cve_by_name
    @cve = RubyCve.where(["dependency_name = ?", params[:id]])
  end

end
