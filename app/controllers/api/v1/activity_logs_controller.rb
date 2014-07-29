module Api
  module V1
    class ActivityLogsController < ApplicationController #Api::BaseController

      respond_to :json

      def index
        @activity_logs = specific_index(ActivityLog, params)
      end

      def show
        @activity_log = specific_show(ActivityLog,params[:id])
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
          params.require(:activity_log).permit(:institution_id, :sender, :receiver, :category, :from_event, :circle_id, :type_of_activity,:message, :read_status)
        end
    end
  end
end
