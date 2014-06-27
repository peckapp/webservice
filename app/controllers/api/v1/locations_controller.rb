module Api
  module V1
    class LocationsController < ApplicationController #Api::BaseController

    # before_action :confirm_admin
    # :except => [:index, :show]
    respond_to :json

    def index
      @locations = Location.all
    end

    def show
      @location = Location.find(params[:id])
    end

    def create
      @location = Location.create(location_params)
    end

    def update
      @location = Location.find(params[:id])
      @location.update_attributes(location_params)
    end

    def destroy
      @location = Location.find(params[:id]).destroy
    end

    private

      def location_params

        params.require(:location).permit(:institution_id, :name, :gps_longitude, :gps_latitude, :range)
      end
    end
  end
end
