module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:dining_period_id]
          @dining_places = DiningPlace.joins(:dining_periods_dining_places).where("dining_places.id" => "dining_periods_dining_places.dining_place_id").joins(:dining_periods).where("dining_periods_dining_places.dining_period_id" => params[:dining_period_id])
          puts "-----------> #{@dining_places}"
        else
          @dining_places = institution_index(DiningPlace)
        end
      end

      def show
        @dining_place = institution_show(DiningPlace)
      end

      def create
        @dining_place = DiningPlace.create(dining_place_params)
      end

      def update
        @dining_place = DiningPlace.find(params[:id])
        @dining_place.update_attributes(dining_place_params)
      end

      def destroy
        @dining_place = DiningPlace.find(params[:id]).destroy
      end

      private

        def dining_place_params
          params.require(:dining_place).permit(:institution_id, :name, :details_link, :gps_longitude, :gps_latitude, :range)
        end
    end
  end
end
