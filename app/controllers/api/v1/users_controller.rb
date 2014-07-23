module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      before_action :confirm_minimal_access, :except => :create

      respond_to :json

      def index
        @users = specific_index(User, params).where("users.first_name IS NOT NULL")
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def create
        @user = User.create
        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      def change_password

        new_pass_params = password_update_params

        @user = User.authenticate(User.find(session[:user_id]).email, params[:user][:password])

        if @user
          @user.old_pass_match = true
          @user.update_attributes(new_pass_params)
        else
          @user = User.find(session[:user_id])
          @user.old_pass_match = false
        end
      end

      def super_create

        # params in the user block
        uparams = params[:user]

        # params for super creating with mass assignment.
        sign_up_params = user_signup_params

        @user = User.find(params[:id])

        if @user
          # makes it necessary for to have a password and password confirmation.
          @user.enable_strict_validation = true

          # assigns the password and password_confirmation from the values in the user block of params.
          sign_up_params[:password] = uparams[:password]
          sign_up_params[:password_confirmation] = uparams[:password_confirmation]

          # gets the image from the params
          sign_up_params[:image] = params[:image]

          @user.update_attributes(sign_up_params)

          @user.authentication_token = SecureRandom.hex(30)
          @user.save
          auth[:authentication_token] = @user.authentication_token
        end
      end

      def update
        @user = User.find(params[:id])
        update_params = user_update_params

        # gets the image from the params
        update_params[:image] = params[:image]
        @user.update_attributes(update_params)
      end

      def destroy
        @user = User.find(params[:id]).destroy
      end

      private
        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :blurb)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
