module Api
  module V1
    class DiningPeriodsController < ApplicationController #Api::BaseController

    # before_action :confirm_admin
    # :except => [:index, :show]

    respond_to :json

    def index
      # If given a dining place id, find all dining periods for that dining place
      if params[:dining_place_id]
        @dining_periods = DiningPeriod.where(:dining_place_id => params[:dining_place_id])

        # If given a dining opportunity id, find all dining periods for that dining opportunity
      elsif params[:dining_opportunity_id]
        @dining_periods = DiningPeriod.where(:dining_opportunity_id => params[:dining_opportunity_id])

      # If given an institution id, find all dining periods for that institution
      elsif params[:institution_id]
        @dining_periods = DiningPeriod.joins(:dining_places).where("circles.institution_id" => params[:institution_id])

        # Otherwise, return all dining periods
      else
        @dining_periods = DiningPeriod.all
      end
    end

    def show
      if params[:dining_place_id]
        @dining_period = DiningPeriod.where(:dining_place_id => params[:dining_place_id]).find(params[:id])

      elsif params[:dining_opportunity_id]
        @dining_period = DiningPeriod.where(:dining_opportunity_id => params[:dining_opportunity_id]).find(params[:id])

      elsif params[:institution_id]
          @dining_period = DiningPeriod.joins(:dining_places).where("circles.institution_id" => params[:institution_id]).find(params[:id])

      else
        @dining_period = DiningPeriod.find(params[:id])
      end
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
        params.require(:dining_period).permit(:dining_place_id, :dining_opportunity_id, :start_time, :end_time, :day_of_week)
      end
    end
  end
end
