module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @simple_events = specific_index(SimpleEvent, params)
      end

      def show
        @simple_event = specific_show(SimpleEvent, params[:id])
      end

      def create
        event_params = simple_event_params
        event_params[:image] = params[:image]
        @simple_event = SimpleEvent.create(event_params)
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
          params.require(:simple_event).permit(:title, :event_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :event_url, :public, :comment_count, :start_date, :end_date)
        end
    end
  end
end
