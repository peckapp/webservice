module Api
  module V1
    class DiningPeriodsController < ApplicationController
      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      def index
        @dining_periods = specific_index(DiningPeriod, params)
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
