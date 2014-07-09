module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:dining_opportunity_id]
          # @dining_places = DiningOpportunity.where("dining_opportunities.id" => params[:dining_opportunity_id]).joins(:dining_opportunities_dining_places).where("dining_opportunities.id" => "dining_opportunities_dining_places.dining_opportunity_id").joins(:dining_places).where("dining_opportunities_dining_places.dining_place_id" => "dining_places.id")
          @dining_places = DiningOpportunity.find(params[:dining_opportunity_id]).dining_places

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
