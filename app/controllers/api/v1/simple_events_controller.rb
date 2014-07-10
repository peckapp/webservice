module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      respond_to :json

      def index

        @simple_events = specific_index(SimpleEvent, params)

        for event in @simple_events
          event.image_url = valid_event_image(event)
        end
      end

      def show
        @simple_event = specific_show(SimpleEvent, params[:id])

        @simple_event.image_url = valid_event_image(@simple_event)
      end

      def create
        @simple_event = SimpleEvent.create(simple_event_params)
      end

      def update
        @simple_event = SimpleEvent.find(params[:id])
        @simple_event.update_attributes(simple_event_params)
      end

      def destroy
        @simple_event = SimpleEvent.find(params[:id]).destroy
      end

      private

        def simple_event_params
          params.require(:simple_event).permit(:title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :open, :image_url, :comment_count, :start_date, :end_date)
        end

        # return a default image url if it is null
        def valid_event_image(event)
          if event.image_url = "null"
            "/images/event.png"
          else
            event.image_url
          end
        end

    end
  end
end
