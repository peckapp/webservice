module Api
  module V1
    class AthleticEventsController < ApplicationController
      before_action :confirm_logged_in, only: [:create, :update, :destroy]

      respond_to :json

      def index
        @athletic_events = specific_index(AthleticEvent, params)

        # event attendees
        @attendee_ids = {}

        all_attendees = EventAttendee.where('category' => 'athletic').pluck(:event_attended, :user_id)

        @athletic_events.each do |event|

          attendee_ids = []

          all_attendees.each do |att|
            next unless att[0] == event.id
            attendee_ids << att[1]
          end

          @attendee_ids[event.id] = attendee_ids
        end

        # athletic_subscription_ids = Subscription.where(user_id: params[:user_id], category: 'athletic').pluck(:subscribed_to)
      end

      def show
        @athletic_event = specific_show(AthleticEvent, params[:id])

        # event attendees
        @attendee_ids = {}

        all_attendees = EventAttendee.where(category: 'athletic', event_attended: @athletic_event.id).pluck(:event_attended, :user_id)

        @attendee_ids = []

        all_attendees.each do |att|
          next unless att[0] == @athletic_event.id
          attendee_ids << att[1]
        end
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
        params.require(:athletic_event).permit(:institution_id, :athletic_team_id, :opponent, :team_score,
                                               :opponent_score, :home_or_away, :location, :result, :note, :start_time)
      end
    end
  end
end
