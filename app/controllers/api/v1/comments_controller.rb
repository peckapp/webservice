module Api
  module V1
    class CommentsController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      respond_to :json

      def index
        search_params = []

        for key in params.keys do
          break if key == "format" || "authentication"
          search_params << key
        end
        @comments = specific_index(Comment, search_params)
        
      end

      def show
        @comment = Comment.find(params[:id])
      end

      def create
        @comment = Comment.create(comment_params)
      end

      def update
        @comment = Comment.find(params[:id])
        @comment.update_attributes(comment_params)
      end

      def destroy
        @comment = Comment.find(params[:id]).destroy
      end

      private

        def comment_params
          params.require(:comment).permit(:institution_id, :category, :comment_from, :user_id, :content)
        end
    end
  end
end
