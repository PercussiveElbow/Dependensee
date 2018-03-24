require_relative '../lib/msg_constants'

class CveController < ApplicationController
  before_action :find_cve_by_id, only: [:show]
  skip_before_action :auth_req

  api :GET, '/cve/:cve_id/', 'Get a CVE'
  param :id, String, :desc => 'ID of CVE format 20XX-XXXX', :required=>true
  def show
    resp = @cve.as_json
    if !resp.empty?
      resp = has_found_cve(resp)
      return json_response(resp)
    end
    raise CustomException::NotFound, MsgConstants::NOT_FOUND
  end

  def has_found_cve(resp)
    if !resp[0].empty?
      resp = resp[0]
      resp['language'] = @language if !@language.nil?
    end
    resp
  end

  # def name_or_cve
  #   !params[:id][/\p{L}/].nil? ? find_cve_by_name : find_cve_by_id
  # end

  def find_cve_by_id
      param_validate
      @cve = RubyCve.where(['cve_id = ?', params[:id]])
      if !set_lang?('Ruby')
        @cve = JavaCve.where(['cve_id = ?', params[:id]])
        if !set_lang?('Java')
          @cve = PythonCve.where(['cve_id = ?', params[:id]])
            set_lang?('Python')
        end
      end
  end

  def param_validate
    begin
      param! :id, String, required: true, format:  /^\d{4}-(0\d{3}|[1-9]\d{3,})$/
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end
  end

  def set_lang?(lang)
    if !@cve.nil? and !@cve.empty?
      @language = lang
      true
    else
      false
    end
  end

  # def find_cve_by_name
  #   @cve = RubyCve.where(['dependency_name = ?', params[:id]])
  # end

end
