module Api
  module V1
    class DiningPeriodsController < ApplicationController #Api::BaseController
    
    # before_action :confirm_admin
    # :except => [:index, :show]

    respond_to :json

    def index
      @dining_periods = DiningPeriod.all
    end

    def show
      @dining_period = DiningPeriod.find(params[:id])
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
