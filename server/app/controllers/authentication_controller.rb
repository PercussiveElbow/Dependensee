# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  skip_before_action :auth_req, only: :authenticate

  def authenticate # return token
    json_response(auth_token: AuthUser.new(auth_params[:email], auth_params[:password]).call)
  end

  private
  def auth_params
    params.permit(:email, :password)
  end
end