module Api
  module V1
    class EventCommentsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @event_comments = EventComment.all
    end

    def show
      @event_comment = EventComment.find(params[:id])
    end

    def create
      @event_comment = EventComment.create(event_comment_params)
    end

    def update
      @event_comment = EventComment.find(params[:id])
      @event_comment.update_attributes(event_comment_params)
    end

    def destroy
      @event_comment = EventComment.find(params[:id]).destroy
    end

    private

      def event_comment_params
        params.require(:event_comment).permit(:category, :comment_from, :user_id, :comment)
      end
    end
  end
end
