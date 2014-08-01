module Api
  module V1
    class SimpleEventsController < ApplicationController

      before_action :confirm_logged_in, only: [:create, :update, :destroy, :add_like, :unlike]

      respond_to :json

      def index
        # get all simple events given provided params
        @simple_events = specific_index(SimpleEvent, params)

        # initialize hash mapping events to arrays of likers
        @likes_for_simple_event = {}

        # get ids of all comments
        simple_event_ids = @simple_events.pluck(:id)

        all_likes = Like.where(:likeable_type => "SimpleEvent").where(:likeable_id => simple_event_ids)

        @simple_events.each do |event|
          liker_ids = all_likes.where(:likeable_id => event.id).pluck(:liker_id)
          @likes_for_simple_event[event] = liker_ids
        end

        # event attendees
        @attendee_ids = {}

        @simple_events.each do |se|
          @attendee_ids[se.id] = EventAttendee.where('category' => 'simple').where('event_attended' => se.id).pluck(:user_id)
        end
      end

      def show
        @simple_event = specific_show(SimpleEvent, params[:id])

        @likers = Like.where(:likeable_type => "SimpleEvent").where(:likeable_id => @simple_event.id).pluck(:id)

        @attendee_ids = EventAttendee.where('category' => 'simple').where('event_attended' => @simple_event.id).pluck(:user_id)

      end

      def create
        event_params = simple_event_params

        # gets the image from params
        event_params[:image] = params[:image]
        @simple_event = SimpleEvent.create(event_params)
      end

      def update
        @simple_event = SimpleEvent.find(params[:id])
        update_params = simple_event_params

        # gets the image from params
        update_params[:image] = params[:image]
        @simple_event.update_attributes(update_params)
      end

      def add_like
        @simple_event = SimpleEvent.find(params[:id])
        if params[:liker].to_i == auth[:user_id].to_i
          liker = User.find(params[:liker])
          liker.like!(@simple_event)
          @likers = @simple_event.likers(User)
          @likes = []
          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def unlike
        @simple_event = SimpleEvent.find(params[:id])
        if params[:unliker].to_i == auth[:user_id].to_i
          liker = User.find(params[:unliker])
          liker.unlike!(@simple_event)

          @likers = @simple_event.likers(User)
          @likes = []

          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def destroy
        @simple_event = SimpleEvent.find(params[:id]).destroy
      end

      private

        def simple_event_params
          params.require(:simple_event).permit(:title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :public, :comment_count, :start_date, :end_date)
        end
    end
  end
end
