module Api
  module V1
    class PushNotificationsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin

      respond_to :json

      def index
        if params[:user_id]
          @push_notifications = specific_index(PushNotification, :user_id)
        else
          @push_notifications = PushNotification.all
        end
      end

      def show
        if params[:user_id]
          @push_notification = specific_show(PushNotification, :user_id)
        else
          @push_notification = PushNotification.find(params[:id])
        end
      end

      def create
        @push_notification = PushNotification.create(push_notification_params)
      end

      def update
        @push_notification = PushNotification.find(params[:id])
        @push_notification.update_attributes(push_notification_params)
      end

      def destroy
        @push_notification = PushNotification.find(params[:id]).destroy
      end

      private

        def push_notification_params

          params.require(:push_notification).permit(:user_id, :institution_id, :notification_type, :response)

        end
    end
  end
end
