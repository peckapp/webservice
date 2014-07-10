module Api
  module V1
    class DiningOpportunitiesController < ApplicationController #Api::BaseController

      # before_action :confirm_admin
      # :except => [:index, :show]
      respond_to :json

      def index
        @dining_opportunities = specific_index(DiningOpportunity, params)
        @service_hours = {}

        if params[:day_of_week]

          for opp in @dining_opportunities

            begin_time = earliest_start(opp, params[:day_of_week])
            finish_time = latest_end(opp, params[:day_of_week])

            if ! begin_time.blank? && ! finish_time.blank?
              start_time = begin_time.strftime("%I:%M%p")
              end_time = finish_time.strftime("%I:%M%p")
              hours = "#{start_time} - #{end_time}"
              @service_hours[opp.id] = hours
            end
          end
        end

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

        # methods to sort through earliest/latest times
        def earliest_start(opportunity_id, day_of_week)
          start_times = DiningPeriod.where({ "dining_periods.dining_opportunity_id" => opportunity_id, "dining_periods.day_of_week" => day_of_week }).pluck(:start_time)

          earliest = nil

          for t in start_times
            if earliest == nil
              earliest = t
            elsif t < earliest
              earliest = t
            end
          end

          earliest

        end

        def latest_end(opportunity_id, day_of_week)
          end_times = DiningPeriod.where({ "dining_periods.dining_opportunity_id" => opportunity_id, "dining_periods.day_of_week" => day_of_week }).pluck(:end_time)

          latest = nil

          for t in end_times
            if latest == nil
              latest = t
            elsif t > latest
              latest = t
            end
          end

          latest

        end

    end
  end
end
