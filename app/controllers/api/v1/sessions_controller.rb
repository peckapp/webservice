class SessionsController < ApplicationController

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      session[:user_id] = user.id
    end
  end

  def destroy
    session[:user_id] = nil
  end
end
