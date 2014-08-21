module Api
  module V1
    class UniqueDeviceIdentifiersController < ApplicationController

      # before_action :authenticate_admin_user!
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        if params[:user_id]
          @unique_device_identifiers = specific_index(UniqueDeviceIdentifier, params)
        else
          @unique_device_identifiers = UniqueDeviceIdentifier.all
        end
      end

      def show
        @unique_device_identifier = specific_show(UniqueDeviceIdentifier, params[:id])
      end

      def create
      end

      def update
        @unique_device_identifier = UniqueDeviceIdentifier.find(params[:id])
        @unique_device_identifier.update_attributes(unique_device_identifier_params)
      end

      def destroy
        @unique_device_identifier = UniqueDeviceIdentifier.find(params[:id]).destroy
      end

      private

      def unique_device_identifier_params
        params.require(:unique_device_identifier).permit(:udid)
      end
    end
  end
end
