module Api
  module V1
    class AthleticEventsController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @athletic_events = specific_index(AthleticEvent, params)

        @attendee_ids = EventAttendee.where(user_id: params[:user_id], category: 'athletic').pluck(:event_attended)

        # athletic_subscription_ids = Subscription.where(user_id: params[:user_id], category: 'athletic').pluck(:subscribed_to)
      end

      def show
        @athletic_event = specific_show(AthleticEvent, params[:id])
      end

      def create
        @athletic_event = AthleticEvent.create(athletic_event_params)
      end

      def update
        @athletic_event = AthleticEvent.find(params[:id])
        @athletic_event.update_attributes(athletic_event_params)
      end

      def destroy
        @athletic_event = AthleticEvent.find(params[:id]).destroy
      end

      private

        def athletic_event_params
          params.require(:athletic_event).permit(:institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,:location, :result, :note, :start_time)
        end
    end
  end
end
