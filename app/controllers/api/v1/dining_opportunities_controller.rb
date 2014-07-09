module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        @dining_opportunities = specific_index(DiningOpportunity, params)
      end

      def show
        @dining_opportunity = specific_show(DiningOpportunity, :institution_id)
      end

      def create
        @dining_opportunity = DiningOpportunity.create(dining_opportunity_create_params)

        if dining_opportunity_create_params[:dining_place_id]
          @dining_period_id = dining_opportunity_create_params[:dining_place_id]
          DiningPlace.find(@dining_place_id).dining_opportunities << @dining_opportunity
        end
      end

      def update
        # does not allow changing of dining period id because of many-to-many ambiguity.
        @dining_opportunity = DiningOpportunity.find(params[:id])
        @dining_opportunity.update_attributes(dining_opportunity_update_params)
      end

      def destroy
        @dining_opportunity = DiningOpportunity.find(params[:id]).destroy
      end

      private

        def dining_opportunity_create_params
          params.require(:dining_opportunity).permit(:dining_opportunity_type, :institution_id, :dining_place_id)
        end

        def dining_opportunity_update_params
          params.require(:dining_opportunity).permit(:dining_opportunity_type, :institution_id)
        end
    end
  end
end
