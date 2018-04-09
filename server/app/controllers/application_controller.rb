# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
   # Base application controller, calls auth by default
   before_action :auth_req
   attr_reader :current_user

   include Response
   include CustomException

   private
   def auth_req # return authed user
      @current_user = (AuthReq.new(request.headers).call)[:user]
   end

end