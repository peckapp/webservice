module Api
  module V1
    class SimpleEventsController < ApplicationController #Api::BaseController

    respond_to :json
    # def create
    #   @simple_event = SimpleEvent.new(params[simple_event_params])
    #   respond_to do |format|
    #     if @simple_event.save
    #       format.json { render json: @simple_event, status: :created}
    #       format.xml { render xml: @simple_event, status: :created}
    #     else
    #       format.json { render json: @simple_event.errors, status: :unprocessable_entity }
    #       format.xml { render json: @simple_event.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end

    def index
      @simple_events = SimpleEvent.all
    end

    def show
      @simple_event = SimpleEvent.find(params[:id])
    end

    def update
      @simple_event = SimpleEvent.find(params[:id])
      respond_to do |format|
        if @simple_event.update_attributes(params[simple_event_params])
          format.json { render json: @simple_event, status: :ok}
          format.xml { render xml: @simple_event, status: :ok}
        else
          format.json { render json: @simple_event.errors, status: :unprocessable_entity}
          format.xml { render xml: @simple_event.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @simple_event = SimpleEvent.find(params[:id])
      respond_to do |format|
        if @simple_event.destroy
          format.json { head :no_content, status: :ok}
          format.xml { head :no_content, status: :ok}
        else
          format.json { render json: @simple_event.errors, status: :unprocessable_entity}
          format.xml { render xml: @simple_event.errors, status: :unprocessable_entity}
        end
      end
    end
    end
  end
end
