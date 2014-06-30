module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

    # before_action :confirm_logged_in
    # :except => [:index, :show]

    respond_to :json
    # @default_image_url = "/images/event.png"

    def index
      if params[:institution_id]
        @simple_events = SimpleEvent.where(:institution_id => params[:institution_id])
      else
        @simple_events = SimpleEvent.sorted
      end
      # return a default image url if it is null
      for event in @simple_events
        if event.image_url = "null"
          event.image_url = "/images/event.png"
        end
      end
    end

    def show
      @simple_event = institution_show(SimpleEvent)

      # return a default image url if it is null
      if @simple_event.image_url = "null"
        @simple_event.image_url = "/images/event.png"
      end
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
    end
  end
end
