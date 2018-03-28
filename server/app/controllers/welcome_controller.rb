# app/controllers/welcome_controller.rb
class WelcomeController < ActionController::Base

  def show
    @hostname = request.host
    @production ||=(ENV['RAILS_ENV']=='production')
    render :welcome
  end
end