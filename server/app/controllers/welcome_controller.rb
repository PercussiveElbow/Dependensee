# app/controllers/welcome_controller.rb
class WelcomeController < ActionController::Base
  # Welcome controller so root route presents page on production mode

  def show
    @hostname = request.host
    @production ||=(ENV['RAILS_ENV']=='production')
    render :welcome
  end
end