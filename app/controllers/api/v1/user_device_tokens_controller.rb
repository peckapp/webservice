module Api
  module V1
    class UserDeviceTokensController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
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
        @user_device_token = UserDeviceToken.create(user_device_token_params)
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

          params.require(:user_device_token).permit(:institution_id, :user_id, :token)

        end
    end
  end
end
