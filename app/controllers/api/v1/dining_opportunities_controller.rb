module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        # if given a dining period id, find all dining opportunities with that dining period id.
        if params[:dining_period_id]
          @dining_opportunities = DiningPeriod.find(params[:dining_period_id]).dining_opportunities
        # otherwise, follow the template from the application controller.
        else
          @dining_opportunities = specific_index(DiningOpportunity, :institution_id)
        end
      end

      def show
        if params[:dining_period_id]
          @dining_opportunity = DiningPeriod.find(params[:dining_period_id]).dining_opportunities.find(params[:id])
        else
          @dining_opportunity = specific_show(DiningOpportunity, :institution_id)
        end
      end

      def create
        # will return error if parameter for dining period id is not provided
        @dining_opportunity = DiningOpportunity.create(dining_opportunity_create_params)
        @dining_period_id = dining_opportunity_create_params[:dining_period_id]
          DiningPeriod.find(@dining_period_id).dining_opportunities << @dining_opportunity
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
          params.require(:dining_opportunity).permit(:dining_opportunity_type, :institution_id, :dining_period_id)
        end

        def dining_opportunity_update_params
          params.require(:dining_opportunity).permit(:dining_opportunity_type, :institution_id)
        end
    end
  end
end
