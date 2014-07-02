module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        # @users = institution_index(User)
        @users = User.where(:institution_id => params[:institution_id])
      end

      def show
        @user = institution_show(User)
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

          # not allowed for mass assignment are: authentication_token, password_digest, created_at, updated_at
          params.require(:user).permit(:institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :facebook_token, :api_key, :active)

        end
    end
  end
end
