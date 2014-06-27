module Api
  module V1
    class NotificationViewsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @notification_views = NotificationView.all
    end

    def show
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
