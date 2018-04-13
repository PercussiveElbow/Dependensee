# app/controllers/updates_controller.rb
require_relative '../lib/common/generic_version_logic'
require_relative '../lib/common/update_deps'
require_relative '../lib/msg_constants'

class UpdatesController < ProjectAndScanValidatorController
  # Updates /projects/project_id/scans/scan_id

def_param_group :project_and_scan do
    param :project_id, String, :desc => 'Project ID (UUID) ', :required => true
    param :scan_id, String,:desc=> 'Scan ID (UUID)', :required => true
  end

  api :POST, '/projects/:project_id/scans/:scan_id/updates/:type', 'Request an Update'
  param_group :project_and_scan
  param :type, %w(safe latest manual), :required => true
  def create # method to call update logic and return response
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

end