class CveController < ApplicationController
  before_action :find_cve_by_id, only: [:show]
  skip_before_action :auth_req

  # GET /cve/:cve_id
  def show
    json_response(@cve)
  end


  def find_cve_by_id
    @cve = RubyCve.where(["cve_id = ?", params[:id]])
  end

end
