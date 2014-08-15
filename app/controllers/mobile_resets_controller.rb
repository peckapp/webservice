class MobileResetsController < ApplicationController
  before_action :confirm_minimal_access, except: [:apple, :android, :desktop]

  def desktop
    the_id = params.delete(:id)
    user = User.find(the_id)
    new_pass_params = pass_reset_params
    user.update_attributes(new_pass_params)
    
    if apple_request?
      redirect_to apple_mobile_resets_url(id: user.id)
    elsif android_request?
      redirect_to android_mobile_resets_url(id: user.id)
    end
  end

  def apple
    @user = User.find(params[:id])
  end

  def android
    @user = User.find(params[:id])
  end

  private

  def pass_reset_params
    params.require(:user).permit(:password)
  end
end
