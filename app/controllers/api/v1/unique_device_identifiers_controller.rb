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
        @unique_device_identifier = UniqueDeviceIdentifier.create(unique_device_identifier_params)
      end

      def update
        @unique_device_identifier = UniqueDeviceIdentifier.find(params[:id])
        @unique_device_identifier.update_attributes(unique_device_identifier_params)
      end

      def update_token
        udid = unique_device_identifier_params[:udid]
        token = unique_device_identifier_params[:token]

        if UniqueDeviceIdentifier.exists?(udid: udid, token: token)
          # token and UDID pair already exists, no action necessary
          head :accepted
        else
          # get the updated token object from one matching either parameter
          @unique_device_identifier = UniqueDeviceIdentifier.updated_udid_token_pair(udid, token)
          if @unique_device_identifier.nil?
            head :not_found
          elsif @unique_device_identifier.save
            head :accepted
          else
            logger.error "error updating token on unique_device_identifier: #{@unique_device_identifier.errors.messages}"
            head :bad_request
          end
        end
      end

      def destroy
        @unique_device_identifier = UniqueDeviceIdentifier.find(params[:id]).destroy
      end

      private

      def unique_device_identifier_params
        params.require(:unique_device_identifier).permit(:udid, :token)
      end
    end
  end
end
