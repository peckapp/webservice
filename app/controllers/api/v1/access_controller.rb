class AccessController < ApplicationController
  # 
  # before_action :confirm_logged_in, :except => [:attempt_login, :logout]
  #
  # def index
  #   @user = User.find()
  # end
  #
  # def attempt_login
  #   if params[:username].present && params[:password].present?
  #     found_user = User.where(:username => params[:username]).first
  #     if found_user
  #       authorized_user = found_user.authenticate(params[:password])
  #     end
  #   end
  #
  #   if authorized_user
  #     session[:user_id] = authorized_user.id
  #     session[:username] = authorized_user.username
  #     .....
  #   else
  #   end
  # end
  #
  # def logout
  #   session[:user_id] = nil
  #   session[:username] = nil
  #   .....
  # end
end
