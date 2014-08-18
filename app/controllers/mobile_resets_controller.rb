class MobileResetsController < ApplicationController
  before_action :confirm_minimal_access, except: [:apple, :android, :desktop, :confirmation]
  before_action :the_new_pass_params

  def desktop
    the_id = params.delete(:id)
    user = User.find(the_id)
    new_pass_params = pass_reset_params
    user.update_attributes(new_pass_params)

    if apple_request?
      redirect_to apple_mobile_resets_url(id: user.id)
    elsif android_request?
      redirect_to android_mobile_resets_url(id: user.id)
    else
      redirect_to confirmation_mobile_resets_url
    end
  end

  def apple
    @user = User.find(params[:id])
    @temp_pass = @the_temp_password
  end

  def android
    @user = User.find(params[:id])
    @temp_pass = @the_temp_password
  end

  def confirmation
  end

  private

  def the_new_pass_params
    @the_temp_password = params[:user][:password]
  end

  def pass_reset_params
    params.require(:user).permit(:password)
  end
end
