# app/controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :auth_req

  # POST /signup
  def create
    user = User.create!(whitelist)
    token = AuthUser.new(user.email, user.password).call
    response = {message: MsgConstants::ACC_CREATED, auth_token: token }
    json_response(response, :created)
  end

  # POST /login
  def login
    whitelist_login
    token = AuthUser.new(params['email'], params['password']).call
    response = {message: MsgConstants::LOGGED_ON, auth_token: token }
    json_response(response, :created)
  end

  private

  def whitelist
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def whitelist_login
    params.permit(:email, :password)
  end

end