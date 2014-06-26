module Api
  module V1
    class DiningPlacesController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @dining_places = DiningPlace.all
    end

    def show
      @dining_place = DiningPlace.find(params[:id])
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
