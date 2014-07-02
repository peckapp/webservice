module Api
  module V1
    class EventAttendeesController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:user_id]
          @event_attendees = EventAttendee.where(:attendee => "user_id")
        elsif params[:institution]
          @event_attendees = EventAttendee.joins(:attendee).where("users.institution_id" => params[:institution_id])
        else
          @event_attendees = EventAttendee.all
      end

      def show
        if params[:user_id]
          @event_attendees = EventAttendee.where(:attendee => "user_id").find(params[:id])
        elsif params[:institution]
          @event_attendees = EventAttendee.joins(:attendee).where("users.institution_id" => params[:institution_id]).find(params[:id])
        else
          @event_attendee = EventAttendee.find(params[:id])
      end

      def create
        @event_attendee = EventAttendee.create(event_attendee_params)
      end

      def update
        @event_attendee = EventAttendee.find(params[:id])
        @event_attendee.update_attributes(event_attendee_params)
      end

      def destroy
        @event_attendee = EventAttendee.find(params[:id]).destroy
      end

      private

        def event_attendee_params
          params.require(:event_attendee).permit(:user_id, :added_by, :category, :event_attended)
        end
    end
  end
end
