# app/controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :auth_req

  api :POST, '/signup/', 'Signup'
  param :email, String, :desc=> 'Email for account', :required=>true
  param :name, String, :desc=> 'Name for account', :required=>true
  param :password, String, :desc=> 'Password for account', :required=>true
  param :password_confirmation, String, :required=>true
  def create
    begin
      # param! :name, String, required: true, format: /A-Za-z+/
      param! :email, String, required: true, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      param! :password, String, required: true
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end
    user = User.create!(whitelist)
    token = AuthUser.new(user.email, user.password).call
    response = {message: MsgConstants::ACC_CREATED, auth_token: token }
    json_response(response, :created)
  end

  api :POST, '/login/', 'Login'
  param :email, String, :desc=> 'Email of account', :required=>true
  param :password, String, :desc=> 'Password of account', :required=>true
  def login
    whitelist_login
    begin
      param! :email, String, required: true, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      param! :password, String, required: true
    rescue
      raise CustomException::ValidationError, MsgConstants::VALIDATION_ERROR
    end
    token = AuthUser.new(params[:email], params[:password]).call
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