module Api
  module V1
    class InstitutionsController < ApplicationController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action :confirm_admin, :only => [:create, :update, :destroy]
      respond_to :json

      def index
        @institutions = Institution.where(public: true)
      end

      def show
        @institution = specific_show(Institution, params[:id])
      end

      def create
        # @institution = Institution.create(institution_params)
      end

      def update
        # @institution = Institution.find(params[:id])
        # @institution.update_attributes(institution_params)
      end

      def destroy
        # @institution = Institution.find(params[:id]).destroy
      end

      private

      def institution_params
        params.require(:institution).permit(:name, :street_address, :city, :state, :country, :gps_longitude, :gps_latitude, :range, :configuration_id, :api_key, :email_regex)
      end
    end
  end
end
