module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @simple_events = specific_index(SimpleEvent, params)

        @likes_for_simple_event = {}

        @simple_events.each do |simple_event|
          likers = []
          simple_event.likers(User).each do |user|

            likers << user.id

          end

          @likes_for_simple_event[simple_event] = likers
        end
      end

      def show
        @simple_event = specific_show(SimpleEvent, params[:id])

        @likers = @simple_event.likers(User)
        @likes = []
        if @likers
          @likers.each do |user|
            @likes << user.id
          end
        end
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
        liker = User.find(params[:liker])
        liker.like!(@simple_event)
        @likers = @simple_event.likers(User)
        @likes = []
        @likers.each do |user|
          @likes << user.id
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
