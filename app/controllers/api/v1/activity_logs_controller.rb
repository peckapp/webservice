module Api
  module V1
    class ActivityLogsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @activity_logs = ActivityLog.all
    end

    def show
      @activity_log = ActivityLog.find(params[:id])
    end

    def create
      @activity_log = ActivityLog.create(activity_log_params)
    end

    def update
      @activity_log = ActivityLog.find(params[:id])
      @activity_log.update_attributes(activity_log_params)
    end

    def destroy
      @activity_log = ActivityLog.find(params[:id]).destroy
    end

    private

      def activity_log_params
        params.require(:activity_log).permit(:sender, :receiver, :category, :from_event, :circle_id, :type_of_activity,:message, :read_status, :created_at, :updated_at)
      end
    end
  end
end
