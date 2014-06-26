module Api
  module V1
    class EventViewsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @event_views = EventView.all
    end

    def show
      @event_view = EventView.find(params[:id])
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
        params.require(:event_view).permit(:user_id, :category, :event_viewed, :date_viewed, :created_at, :updated_at)
      end
    end
  end
end
