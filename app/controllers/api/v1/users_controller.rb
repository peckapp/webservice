module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        @users = User.where("users.first_name IS NOT NULL")
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def create
        @user = User.create(user_create_params)
      end

      def super_create
        @user = User.find(params[:id])
        @user.enable_strict_validation = true
        @user.update_attributes(user_signup_params)
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
          params.require(:user).permit(:institution_id)
        end

        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :password, :facebook_link, :active)
        end
    end
  end
end
