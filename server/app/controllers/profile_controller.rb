# app/controllers/profile_controller.rb
class ProfileController < ApplicationController

  def profile_get
    name = current_user.name
    email = current_user.email
    response = {email: email, name: name}
    json_response(response)
  end

end