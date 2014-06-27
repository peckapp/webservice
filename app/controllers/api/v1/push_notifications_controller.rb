module Api
  module V1
    class PushNotificationsController < ApplicationController #Api::BaseController

    # before_action :confirm_admin

    respond_to :json

    def index
      @push_notifications = PushNotification.all
    end

    def show
      @push_notification = PushNotification.find(params[:id])
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

        params.require(:push_notification).permit(:user_id, :type, :response)

      end
    end
  end
end
