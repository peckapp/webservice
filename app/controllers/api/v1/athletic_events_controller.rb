module Api
  module V1
    class AthleticEventsController < ApplicationController
      before_action :confirm_logged_in, only: [:create, :update, :destroy]

      respond_to :json

      def index
        if params[:user_id]
          # events you're attending
          event_attended_ids = EventAttendee.where(user_id: params[:user_id], category: 'athletic').pluck(:event_attended)

          # club subscriptions
          subscription_ids = Subscription.where(user_id: params[:user_id], category: 'athletic').pluck(:subscribed_to)
          subscribed_event_ids = AthleticEvent.where(athletic_team_id: subscription_ids)

          # need to get all events in one query because ActiveRecord associations seemingly cannot be joined
          all_ids = (event_attended_ids + subscribed_event_ids).uniq

          @athletic_events = AthleticEvent.where(id: all_ids)
        else
          # this will add only created events IF user id is provided
          # otherwise all events will be added
          @athletic_events = specific_index(AthleticEvent, params)
        end

        # initialize hash mapping events to arrays of likers
        @likes_for_athletic_event = {}

        # get ids of all comments
        athletic_event_ids = @athletic_events.pluck(:id)
        all_likes = Like.where(likeable_type: 'AthleticEvent').where(likeable_id: athletic_event_ids).pluck(:likeable_id, :liker_id)
        @athletic_events.each do |event|
          liker_ids = []
          all_likes.each do |like|
            liker_ids << like[1] if like[0] == event.id
          end
          @likes_for_athletic_event[event.id] = liker_ids
        end

        ### Event attendees ###

        @attendee_ids = {}
        all_attendees = EventAttendee.where(category: 'athletic').pluck(:event_attended, :user_id)
        @athletic_events.each do |event|
          attendee_ids = []
          all_attendees.each do |att|
            next unless att[0] == event.id
            attendee_ids << att[1]
          end
          @attendee_ids[event.id] = attendee_ids
        end

        # creates a hash of event ids to their corresponding team names
        @team_names_for_ids = {}
        @team_images_for_ids = {}
        teams_hash = Hash[AthleticTeam.all.map { |t| [t.id, t.simple_name] }]
        team_images_hash = Hash[AthleticTeam.all.map { |t| [t.id, t.image] }]
        @athletic_events.each do |event|
          @team_names_for_ids[event.id] = teams_hash[event.athletic_team_id]
          @team_images_for_ids[event.id] = team_images_hash[event.athletic_team_id]
        end
      end

      def show
        @athletic_event = specific_show(AthleticEvent, params[:id])

        # event attendees
        @attendee_ids = {}

        all_attendees = EventAttendee.where(category: 'athletic', event_attended: @athletic_event.id).pluck(:event_attended, :user_id)

        @attendee_ids = []

        all_attendees.each do |att|
          next unless att[0] == @athletic_event.id
          @attendee_ids << att[1]
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
                                               :opponent_score, :home_or_away, :location, :result, :note, :start_date)
      end
    end
  end
end
