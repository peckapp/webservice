module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index

        # make hash of dining places => service hours
        @service_hours = {}

        if params[:dining_opportunity_id] && params[:day_of_week]
          @dining_places = DiningOpportunity.find(params[:dining_opportunity_id]).dining_places

          for place in @dining_places

            start_time = DiningPeriod.where({
              "dining_periods.dining_opportunity_id" => params[:dining_opportunity_id],
              "dining_periods.day_of_week" => params[:day_of_week],
              "dining_periods.dining_place_id" => place.id }).start_time

            end_time = DiningPeriod.where({
              "dining_periods.dining_opportunity_id" => params[:dining_opportunity_id],
              "dining_periods.day_of_week" => params[:day_of_week],
              "dining_periods.dining_place_id" => place.id }).end_time

            hours = "#{start_time} - #{end_time}"

            @service_hours[place.id] << hours
          end
        else
          @dining_places = specific_index(DiningPlace, params)
        end
      end

      def show
        @dining_place = specific_show(DiningPlace, params[:id])
      end

      def create
        @dining_place = DiningPlace.create(dining_place_create_params)

        if dining_place_create_params[:dining_opportunity_id]
          @dining_opportunity_id = dining_place_create_params[:dining_opportunity_id]
          DiningOpportunity.find(@dining_opportunity_id).dining_places << @dining_place
        end
      end

      def update
        @dining_place = DiningPlace.find(params[:id])
        @dining_place.update_attributes(dining_place_update_params)
      end

      def destroy
        @dining_place = DiningPlace.find(params[:id]).destroy
      end

      private

        def dining_place_create_params
          params.require(:dining_place).permit(:institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range, :dining_opportunity_id)
        end

        def dining_place_update_params
          params.require(:dining_place).permit(:institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range)
        end
    end
  end
end
