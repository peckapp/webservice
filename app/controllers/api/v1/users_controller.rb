module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def create
      @user = User.create(user_params)
    end

    def update
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
    end

    def destroy
      @user = User.find(params[:id]).destroy
    end

    private

      def user_params

        params.require(:user).permit(:institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :facebook_token, :password_digest, :api_key, :active, :created_at, :updated_at, :authentication_token)

      end
    end
  end
end
