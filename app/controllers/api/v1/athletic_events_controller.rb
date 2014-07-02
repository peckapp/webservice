module Api
  module V1
    class AthleticEventsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin
      # :except => [:index, :show]

      respond_to :json

      def index
        if params[:athletic_team_id]
          @athletic_events = specific_index(AthleticEvent, :athletic_team_id)
        else
          @athletic_events = specific_index(AthleticEvent, :institution_id)
        end
      end

      def show
        if params[:athletic_team_id]
          @athletic_event = specific_show(AthleticEvent, :athletic_team_id)
        else
          @athletic_event = specific_show(AthleticEvent, :institution_id)
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
          params.require(:athletic_event).permit(:institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,:location, :result, :note, :date_and_time)
        end
    end
  end
end
