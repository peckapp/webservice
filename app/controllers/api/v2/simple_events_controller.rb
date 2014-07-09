module Api
  module V2
    class SimpleEventsController < ApplicationController #Api::BaseController

      respond_to :json, :xml

      def create
        respond_with SimpleEvent.create(params[:id])
      end

      def index
        respond_with SimpleEvent.all
      end

      def show
        respond_with SimpleEvent.find(params[:id])
      end

      def update
        respond_with SimpleEvent.update(params[:id], params[:event])
      end

      def destroy
        respond_with SimpleEvent.find(params[:id]).destroy
      end
    end
  end
end
