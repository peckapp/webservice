module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      before_action :confirm_minimal_access, :except => :create

      respond_to :json

      def index
        req_users = specific_index(User, params)
        @users = req_users.where("users.first_name IS NOT NULL")
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def create
        @user = User.create
        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
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

        @user.update_attributes(sign_up_params)
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes(user_update_params)
      end

      def destroy
        @user = User.find(params[:id]).destroy
      end

      private

        def user_create_params
          # not allowed for mass assignment are: authentication_token, password_digest, created_at, updated_at
          # params.require(:user).permit(:institution_id)
        end

        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :blurb, :password, :password_confirmation)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active)
        end
    end
  end
end
