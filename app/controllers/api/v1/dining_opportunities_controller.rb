module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        # if given a dining period id, find all dining opportunities with that dining period id.
        if params[:dining_period_id]
          @dining_opportunities = DiningOpportunity.where(:dining_period_id => params[:dining_period_id])

        # if given a dining place id, find all dining opportunities for that dining place.
        elsif params[:dining_place_id]
          @dining_opportunities = DiningOpportunity.joins(:dining_places).where("dining_opportunities_dining_places.dining_place_id" =>  params[:dining_place_id])

        # otherwise, follow the institutions template from the application controller.
        else
          @dining_opportunities = institution_index(DiningOpportunity)
        end
      end

      def show
        if params[:dining_period_id]
          @dining_opportunity = DiningOpportunity.where(:dining_period_id => params[:dining_period_id]).find(params[:id])

        elsif params[:dining_place_id]
          @dining_opportunity = DiningOpportunity.where(:dining_place_id => params[:dining_place_id]).find(params[:id])

        else
          @dining_opportunity = institution_show(DiningOpportunity)
        end
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
