module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @dining_opportunities = DiningOpportunity.all
    end

    def show
      @dining_opportunity = DiningOpportunity.find(params[:id])
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
        params.require(:dining_opportunity).permit(:type, :institution_id, :created_at, :updated_at)
      end
    end
  end
end
