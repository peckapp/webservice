module Api
  module V1
    class EventViewsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @event_views = specific_index(EventView, params)
      end

      def show
        @event_view = specific_show(EventView, params[:id])
      end

      def create
        @event_view = EventView.create(event_view_params)
      end

      def update
        @event_view = EventView.find(params[:id])
        @event_view.update_attributes(event_view_params)
      end

      def destroy
        @event_view = EventView.find(params[:id]).destroy
      end

      private

        def event_view_params
          params.require(:event_view).permit(:institution_id, :user_id, :category, :event_viewed, :date_viewed)
        end
    end
  end
end
