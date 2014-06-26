module Api
  module V1
    class EventsPageUrlsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @events_page_urls = EventsPageUrl.all
    end

    def show
      @events_page_url = EventsPageUrl.find(params[:id])
    end

    def create
      @events_page_url = EventsPageUrl.create(events_page_url_params)
    end

    def update
      @events_page_url = EventsPageUrl.find(params[:id])
      @events_page_url.update_attributes(events_page_url_params)
    end

    def destroy
      @events_page_url = EventsPageUrl.find(params[:id]).destroy
    end

    private

      def events_page_url_params
        params.require(:institution_id, :url, :type)
      end
    end
  end
end
