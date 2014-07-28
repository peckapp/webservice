module Api
  module V1
    class CommentsController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy]

      respond_to :json

      def index
        @comments = specific_index(Comment, params)

        @likes_for_comment = {}

        @comments.each do |comment|
          likers = []
          comment.likers(User).each do |user|

            likers << user.id

          end

          @likes_for_comment[comment] = likers
        end
      end

      def show
        @comment = specific_show(Comment,params[:id])

        @likers = @comment.likers(User)
        @likes = []
        if @likers
          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def create
        @comment = Comment.create(comment_params)
      end

      def update
        @comment = Comment.find(params[:id])
        @comment.update_attributes(comment_params)
      end

      def add_like
        @comment = Comment.find(params[:id])
        liker = User.find(params[:liker])
        liker.like!(@comment)
        @likers = @comment.likers(User)
        @likes = []
        @likers.each do |user|
          @likes << user.id
        end
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
