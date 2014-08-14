class RegistrationsController < ApplicationController
  before_action :confirm_minimal_access, except: [:confirm_email, :set_request_format, :set_format_fallbacks]

  # sets the user's activity to true to make sure they're done registering.
  def confirm_email
    @user = User.find(params[:id])
    @user.update_attributes(active: true)

    if apple_request?
      redirect_to_apple_registrations_url
    elsif android_request?
      redirect_to_android_registrations_url
    end
  end

  def apple
  end

  def android
  end
end
