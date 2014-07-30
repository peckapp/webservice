module Api
  module V1
    class UserDeviceTokensController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        if params[:user_id]
          @user_device_tokens = specific_index(UserDeviceToken, params)
        else
          @user_device_tokens = UserDeviceToken.all
        end
      end

      def show
        @user_device_token = specific_show(UserDeviceToken, params[:id])
      end

      def create

      end

      def update
        @user_device_token = UserDeviceToken.find(params[:id])
        @user_device_token.update_attributes(user_device_token_params)
      end

      def destroy
        @user_device_token = UserDeviceToken.find(params[:id]).destroy
      end

      private

        def user_device_token_params

          params.require(:user_device_token).permit(:token)

        end
    end
  end
end
