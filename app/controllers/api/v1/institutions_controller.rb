module Api
  module V1
    class InstitutionsController < ApplicationController #Api::BaseController

    :before_action
    respond_to :json

      def index
        @institutions = Institution.all
      end

      def show
        @institution = Institution.find(params[:id])
      end

      def create
        @institution = Institution.create(institution_params)
      end

      def update
        @institution = Institution.find(params[:id])
        @institution.update_attributes(institution_params)
      end

      def destroy
        @institution = Institution.find(params[:id]).destroy
      end

      private

        def institution_params
          params.require(:institution).permit(:name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range, :configuration_id, :api_key)
        end
    end
  end
end
