module Api
  module V1
    class UserDevicesController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @user_device_tokens = UserDevice.all
    end

    def show
      @user_device_token = UserDevice.find(params[:id])
    end

    def create
      @user_device_token = UserDevice.create(user_device_token_params)
    end

    def update
      @user_device_token = UserDevice.find(params[:id])
      @user_device_token.update_attributes(user_device_token_params)
    end

    def destroy
      @user_device_token = UserDevice.find(params[:id]).destroy
    end

    private

      def user_device_token_params

        params.require(:user_device_token).permit(:user_id, :token)

      end
    end
  end
end
