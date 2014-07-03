module Api
  module V1
    class DiningPeriodsController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      def index

        if params[:institution_id]
          @dining_periods = DiningPeriod.joins(:dining_places).where("dining_places.institution_id" => params[:institution_id])
        else
          search_params = []

          for key in params.keys do
            # break off when irrelevent params are reached
            break if key == "format"
            search_params << key
          end
          @dining_periods = specific_index(DiningPeriod, search_params)
        end

      end

      def show
        if params[:dining_place_id]
          @dining_period = DiningPlace.find(params[:dining_place_id]).dining_periods.find(params[:id])

        elsif params[:dining_opportunity_id]
          @dining_period = DiningOpportunity.find(params[:dining_opportunity_id]).dining_periods.find(params[:id])

        elsif params[:menu_item_id]
            @dining_periods = MenuItem.find(params[:menu_item_id]).dining_periods.find(params[:id])

        elsif params[:institution_id]
            @dining_period = DiningPeriod.joins(:dining_places).where("dining_places.institution_id" => params[:institution_id]).find(params[:id])
        else
          @dining_period = DiningPeriod.find(params[:id])
        end
      end

      def create
        @dining_period = DiningPeriod.create(dining_period_create_params)

        @dining_place_id = dining_period_create_params[:dining_place_id]
          DiningPlace.find(@dining_place_id).dining_periods << @dining_period

        @dining_opportunity_id = dining_period_create_params[:dining_opportunity_id]
          DiningOpportunity.find(@dining_opporunity_id).dining_periods << @dining_period

        @menu_item_id = dining_period_create_params[:menu_item_id]
          MenuItem.find(@menu_item_id).dining_periods << @dining_period
      end

      def update
        @dining_period = DiningPeriod.find(params[:id])
        @dining_period.update_attributes(dining_period_update_params)
      end

      def destroy
        @dining_period = DiningPeriod.find(params[:id]).destroy
      end

      private

        def dining_period_create_params
          params.require(:dining_period).permit(:start_time, :end_time, :day_of_week, :dining_place_id, :dining_opportunity_id, :menu_item_id)
        end

        def dining_period_update_params
          params.require(:dining_period).permit(:start_time, :end_time, :day_of_week)
        end
    end
  end
end
