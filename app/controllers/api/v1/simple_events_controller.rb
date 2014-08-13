require 'new_relic/agent/method_tracer'

module Api
  module V1
    class SimpleEventsController < ApplicationController
      # allows us to track methods calls with new relics toolset
      include ::NewRelic::Agent::MethodTracer

      before_action :confirm_logged_in, only: [:create, :update, :destroy, :add_like, :unlike]

      respond_to :json

      def index
        # get all simple events given provided params
        created_events = specific_index(SimpleEvent, params)

        # this will add only created events IF user id is provided
        # otherwise all events will be added
        @simple_events = created_events

        if params[:user_id]
          # events you're attending
          events_attended_ids = EventAttendees.where(user_id: params[:user_id], category: "simple").pluck(:event_from)
          events_attended = SimpleEvent.where(id: events_attended_ids)
          @simple_events << events_attended

          # club subscriptions
          club_subscription_ids = Subscription.where(user_id: params[:user_id], category: "club").pluck(:subscribed_to)
          club_subscription_events = SimpleEvent.where(category: "club", organizer_id: club_subscription_ids)
          @simple_events << club_subscription_events

          # department subscriptions
          dept_subscription_ids = Subscription.where(user_id: params[:user_id], category: "department").pluck(:subscribed_to)
          dept_subscription_events = SimpleEvent.where(category: "department", organizer_id: club_subscription_ids)
          @simple_events << club_subscription_events
        end


        # initialize hash mapping events to arrays of likers
        @likes_for_simple_event = {}

        # get ids of all comments
        simple_event_ids = @simple_events.pluck(:id)

        all_likes = Like.where(likeable_type: 'SimpleEvent').where(likeable_id: simple_event_ids).pluck(:likeable_id, :liker_id)

        @simple_events.each do |event|

          liker_ids = []

          all_likes.each do |like|
            liker_ids << like[1] if like[0] == event.id
          end

          @likes_for_simple_event[event.id] = liker_ids
        end

        # event attendees
        @attendee_ids = {}

        all_attendees = EventAttendee.where('category' => 'simple').pluck(:event_attended, :user_id)

        @simple_events.each do |event|

          attendee_ids = []

          all_attendees.each do |att|
            if att[0] == event.id
              attendee_ids << att[1]
            end
          end

          @attendee_ids[event.id] = attendee_ids
        end
      end
      add_method_tracer :index, 'SimpleEvent/index'

      def show
        @simple_event = specific_show(SimpleEvent, params[:id])

        @likers = Like.where(likeable_type: 'SimpleEvent').where(likeable_id: @simple_event.id).pluck(:id)

        @attendee_ids = EventAttendee.where('category' => 'simple').where('event_attended' => @simple_event.id).pluck(:user_id)
      end

      def create
        event_params = params[:simple_event]

        # for pecks and push notifications
        event_members = event_params.delete(:event_member_ids)
        the_message = event_params.delete(:message)
        send_push_notification = event_params.delete(:send_push_notification)
        inviter = event_params.delete(:invited_by)

        # # for posting with facebook
        # my_auth_token = event_params.delete(:facebook_token)

        # gets the image from params
        event_params[:image] = params[:image]

        @simple_event = SimpleEvent.create(simple_event_create_params(event_params))

        #### Event Invite ####

        if event_members && @simple_event
          # from the array of user ids
          event_members.each do |member_id|
            user = User.find(member_id)

            # create a peck for that user
            peck = Peck.create(user_id: user.id, institution_id: user.institution_id, notification_type: "event_invite", message: the_message, send_push_notification: send_push_notification, invited_by: inviter, invitation: @simple_event.id, refers_to: @simple_event.id)

            notify(user, peck)
          end
        end
      end
      add_method_tracer :create, 'SimpleEvent/create'

      def check_time_conflicts
        the_start_date = params[:start_date]
        the_end_date = params[:end_date]

        @total_conflicts = []

        # check for conflicts based on start and end date range passed
        start_date_conflicts = SimpleEvent.where(start_date: the_start_date..the_end_date)
        end_date_conflicts = SimpleEvent.where(end_date: the_start_date..the_end_date)

        unless start_date_conflicts.blank?
          start_date_conflicts.each do |event|
            @total_conflicts << event.id
          end
        end

        unless end_date_conflicts.blank?
          end_date_conflicts.each do |event|
            @total_conflicts << event.id
          end
        end

        ### check_time_conflicts view returns the number of conflicts minus the duplicates ###
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

      def simple_event_create_params(parameters)
        parameters.permit(:title, :event_description, :institution_id, :user_id, :category, :organizer_id, :event_url, :public, :comment_count, :image, :start_date, :end_date)
      end

      def simple_event_params
        params.require(:simple_event).permit(:title, :event_description, :institution_id, :user_id, :category, :organizer_id, :event_url, :public, :comment_count, :start_date, :end_date)
      end
    end
  end
end
