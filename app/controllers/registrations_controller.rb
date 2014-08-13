class RegistrationsController < ApplicationController
  before_action :confirm_minimal_access, except: [:confirm_email, :set_request_format]
  before_action :set_request_format, :set_format_fallbacks

  # sets the user's activity to true to make sure they're done registering.
  def confirm_email
    @user = User.find(params[:id])
    @user.update_attributes(active: true)
  end

  def set_request_format
    request.format = :mobile if mobile_request?
  end

  def set_format_fallbacks
    if request.format == :mobile
      self.formats = [:mobile, :html]
    end
  end
end
