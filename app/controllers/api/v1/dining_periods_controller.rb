module Api
  module V1
    class DiningPeriodsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      def index
        @dining_periods = specific_index(DiningPeriod, params)
        @period_start = {}
        @period_end = {}

        if params[:day_of_week].blank?
          # defaults to today's date if no date is specified
          week_day =  DateTime.now.wday
        else
          week_day = params[:day_of_week].to_i
        end

        # need to update these for proper day

        for per in @dining_periods
          # insert start and end time into the view parameters
          @period_start[per.id] = per.start_time
          @period_end[per.id] = per.end_time
        end

      end

      def show
        @dining_period = specific_show(DiningPeriod, params[:id])
      end

      def create
        @dining_period = DiningPeriod.create(dining_period_params)
      end

      def update
        @dining_period = DiningPeriod.find(params[:id])
        @dining_period.update_attributes(dining_period_params)
      end

      def destroy
        @dining_period = DiningPeriod.find(params[:id]).destroy
      end

      private

        def dining_period_params
          params.require(:dining_period).permit(:institution_id, :start_time, :end_time, :day_of_week, :dining_place_id, :dining_opportunity_id)
        end

    end
  end
end
