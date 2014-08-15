class MobileResetsController < ApplicationController
  before_action :confirm_minimal_access, except: [:apple, :android, :desktop]

  def desktop
    user = User.find(params[:id])
    user.update_attributes(password_digest = nil, password_salt = nil)
    user.password = params[:temp]
    user.save
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
end
