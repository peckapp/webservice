module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        @dining_opportunities = specific_index(DiningOpportunity, params)
        @service_hours = {}
        @service_start = {}
        @service_end = {}

        if params[:day_of_week].blank?
          # defaults to today's date if no date is specified
          week_day =  DateTime.now.wday
        else
          week_day = params[:day_of_week].to_i
        end

        for opp in @dining_opportunities

          begin_time = opp.earliest_start(week_day)
          finish_time = opp.latest_end(week_day)

          if ! begin_time.blank? && ! finish_time.blank?
            start_time = begin_time.strftime("%I:%M%p")
            @service_start[opp.id] = begin_time
            end_time = finish_time.strftime("%I:%M%p")
            @service_end[opp.id] = finish_time
            hours = "#{start_time} - #{end_time}"
            @service_hours[opp.id] = hours
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
