module Api
  module V1
    class ActivityLogsController < ApplicationController #Api::BaseController


      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:user_id]
          @activity_logs = ActivityLog.where(:receiver => params[:user_id])
        elsif params[:circle_id]
          @activity_logs = specific_index(ActivityLog, :circle_id)
        else
          @activity_logs = ActivityLog.all
        end
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
