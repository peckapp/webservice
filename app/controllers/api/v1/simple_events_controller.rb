module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @simple_events = SimpleEvent.all
    end

    def show
      @simple_event = SimpleEvent.find(params[:id])
    end

    def create
      @simple_event = SimpleEvent.create(simple_event_params)
    end

    def update
      @simple_event = SimpleEvent.find(params[:id]).update_attributes(simple_event_params)
    end

    def destroy
      @simple_event = SimpleEvent.find(params[:id]).destroy
    end

    private

      def simple_event_params
        params.require(:simple_event).permit(:title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :open, :image_url, :comment_count, :start_date, :end_date, :created_at, :updated_at)
      end
    end
  end
end
