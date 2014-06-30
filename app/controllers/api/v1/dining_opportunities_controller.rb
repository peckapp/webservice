module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        @dining_opportunities = institution_index(DiningOpportunity)
      end

      def show
        @dining_opportunity = institution_show(DiningOpportunity)
      end

      def create
        @dining_opportunity = DiningOpportunity.create(dining_opportunity_params)
      end

      def update
        @dining_opportunity = DiningOpportunity.find(params[:id])
        @dining_opportunity.update_attributes(dining_opportunity_params)
      end

      def destroy
        @dining_opportunity = DiningOpportunity.find(params[:id]).destroy
      end

      private

        def dining_opportunity_params
          params.require(:dining_opportunity).permit(:type, :institution_id)
        end
    end
  end
end
