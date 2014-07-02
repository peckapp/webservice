module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        @users = specific_index(User, :institution_id)
      end

      def show
        @user = specific_show(User, :institution_id)
      end

      def create
        uparams = user_params

        # add authentication token that is randomly generated
        uparams[:api_key] = SecureRandom.hex(25)

        @user = User.create(uparams)
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
          params.require(:user).permit(:institution_id, :first_name, :last_name, :username, :blurb, :facebook_link, :active)
        end

    end
  end
end
