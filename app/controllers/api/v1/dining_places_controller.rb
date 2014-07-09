module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        @dining_places = specific_index(DiningPlace, params)
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
