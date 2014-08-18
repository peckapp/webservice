class MobileResetsController < ApplicationController
  before_action :confirm_minimal_access, except: [:apple, :android, :desktop, :confirmation]

  def desktop
    the_id = params.delete(:id)
    user = User.find(the_id)
    new_pass_params = pass_reset_params
    user.update_attributes(new_pass_params)
    # temp_pass = new_pass_params[:password]

    if apple_request?
      redirect_to apple_mobile_resets_url(id: user.id) #, temp: temp_pass)
    elsif android_request?
      redirect_to android_mobile_resets_url(id: user.id) #, temp: temp_pass)
    else
      redirect_to confirmation_mobile_resets_url
    end
  end

  def apple
    @user = User.find(params[:id])
    #@temp_pass = params[:temp]
  end

  def android
    @user = User.find(params[:id])
    #@temp_pass = params[:temp]
  end

  def confirmation
  end

  private

  def pass_reset_params
    params.require(:user).permit(:password)
  end
end
