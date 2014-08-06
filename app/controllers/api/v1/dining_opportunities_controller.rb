module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        dining_opps = specific_index(DiningOpportunity, params)
        @dining_opportunities = []
        @service_start = {}
        @service_end = {}

        if params[:day_of_week].blank?
          # defaults to today's date if no date is specified
          week_day =  DateTime.now.wday
        else
          week_day = params[:day_of_week].to_i
        end

        # get earliest start and latest end of each dining opp
        dining_times = DiningOpportunity.earliest_start_latest_end(week_day)

        for opp in dining_opps

          if dining_times[opp.id] != nil && ! dining_times[opp.id][0].blank? && ! dining_times[opp.id][1].blank?

            @service_start[opp.id] = dining_times[opp.id][0]
            @service_end[opp.id] = dining_times[opp.id][1]
            @dining_opportunities << opp

          end
        end
      end

      def show
        @dining_opportunity = specific_show(DiningOpportunity, params[:id])
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
