class RegistrationsController < ApplicationController
  before_action :confirm_minimal_access, except: :confirm_email

  # sets the user's activity to true to make sure they're done registering.
  def confirm_email
    @user = User.find(params[:id])
    @user.update_attributes(active: true)
    # redirect_to("http://peckapp.com")
  end
end
