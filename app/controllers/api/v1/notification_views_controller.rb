module Api
  module V1
    class NotificationViewsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin

      respond_to :json

      def index
        if params[:user_id]
          @notification_views = specific_index(NotificationView, :user_id)
        else
          @notification_views = NotificationView.all
      end

      def show
        if params[:user_id]
          @notification_view = specific_show(NotificiationView, :user_id)
        else
          @notification_view = NotificationView.find(params[:id])
      end

      def create
        @notification_view = NotificationView.create(notification_view_params)
      end

      def update
        @notification_view = NotificationView.find(params[:id])
        @notification_view.update_attributes(notification_view_params)
      end

      def destroy
        @notification_view = NotificationView.find(params[:id]).destroy
      end

      private

        def notification_view_params

          params.require(:notification_view).permit(:user_id, :activity_log_id, :date_viewed, :viewed)

        end
    end
  end
end
