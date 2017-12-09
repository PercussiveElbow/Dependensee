class CveController < ApplicationController
  before_action :find_cve_by_id, only: [:show]
  skip_before_action :auth_req

  # GET /cve/:cve_id
  def show
    resp = @cve.as_json
    if !resp[0].empty?
          resp = resp[0]
          resp['language'] = @language if !@language.nil?
    end
    return json_response(resp)
  end

  # def name_or_cve
  #   !params[:id][/\p{L}/].nil? ? find_cve_by_name : find_cve_by_id
  # end

  def find_cve_by_id
    @cve = RubyCve.where(['cve_id = ?', params[:id]])
    if !@cve.nil? and !@cve.empty?
      @language = 'Ruby'
    else
      @cve = JavaCve.where(['cve_id = ?', params[:id]])
      if !@cve.nil? and !@cve.empty?
        @language = 'Java'
      else
        @cve = PythonCve.where(['cve_id = ?', params[:id]])
        if !@cve.nil? and !@cve.empty?
          @language = 'Python'
        end
      end
    end
  end

  # def find_cve_by_name
  #   @cve = RubyCve.where(['dependency_name = ?', params[:id]])
  # end

end
