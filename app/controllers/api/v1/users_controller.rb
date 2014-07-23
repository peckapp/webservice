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

        # puts "NEW_PASS_PARAMS -------> #{new_pass_params}"
        # puts "PARAMS[:PASSWORD] ----------> #{params[:user][:password]}"
        # puts "USER EMAIL -------> #{User.find(session[:user_id]).email}"

        @user = User.authenticate(User.find(session[:user_id]).email, params[:user][:password])

        # puts "------> #{@user} <-------"

        if @user
          @user.update_attributes(new_pass_params)
        end
      end

      def super_create

        # params in the user block
        uparams = params[:user]

        # params for super creating, making mass assignment unecessary.
        sign_up_params = user_signup_params

        @user = User.find(params[:id])

        # makes it necessary for to have a password and password confirmation.
        @user.enable_strict_validation = true

        # assigns the password and password_confirmation from the values in the user block of params.
        sign_up_params[:password] = uparams[:password]
        sign_up_params[:password_confirmation] = uparams[:password_confirmation]

        # sign_up_params[:authentication_token] = SecureRandom.hex(30)

        @user.update_attributes(sign_up_params)

        if @user
          @user.authentication_token = SecureRandom.hex(30)
          @user.save
          auth[:authentication_token] = @user.authentication_token
        end
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes(user_update_params)
      end

      def destroy
        @user = User.find(params[:id]).destroy
      end

      private
        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :blurb, :password, :password_confirmation, :image)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active, :image)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
