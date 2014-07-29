module Api
  module V1
    class EventAttendeesController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action :confirm_logged_in, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @event_attendees = specific_index(EventAttendee, params)
      end

      def show
        @event_attendee = specific_show(EventAttendee, params[:id])
      end

      def create
        @event_attendee = EventAttendee.create(event_attendee_params)
      end

      def update
        @event_attendee = EventAttendee.find(params[:id])
        @event_attendee.update_attributes(event_attendee_params)
      end

      def destroy
        @event_attendee = EventAttendee.where(:institution_id => delete_params[:institution_id]).where(:user_id => delete_params[:user_id]).where(:category => delete_params[:category]).where(:event_attended => delete_params[:event_attended]).first.destroy
      end

      private

        def event_attendee_params
          params.require(:event_attendee).permit(:institution_id, :user_id, :added_by, :category, :event_attended)
        end

        def delete_params
          params.require(:event_attendee).permit(:institution_id, :user_id, :category, :event_attended)
        end
    end
  end
end
