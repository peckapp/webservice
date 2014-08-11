module Api
  module V1
    class CommentsController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy, :add_like, :unlike] # touching little boys

      respond_to :json

      def index
        @comments = specific_index(Comment, params)

        @likes_for_comment = {}

        # get ids of all comments
        comment_ids = @comments.pluck(:id)

        all_likes = Like.where(:likeable_type => "Comment").where(:likeable_id => comment_ids).pluck(:likeable_id, :liker_id)

        @comments.each do |comment|

          liker_ids = []

          all_likes.each do |like|
            if like[0] == comment.id
              liker_ids << like[1]
            end
          end

          @likes_for_comment[comment] = liker_ids
        end
      end

      def show
        @comment = specific_show(Comment,params[:id])

        @likers = Like.where(:likeable_type => "Comment").where(:likeable_id => @comment.id).pluck(:id)

      end

      def create
        cparams = params[:comment]

        the_message = cparams.delete(:message)
        send_push_notification = cparams.delete(:send_push_notification)

        @comment = Comment.create(comment_create_params(cparams))

        ##### Circle Comment Push Notifications #####
        if @comment && @comment.category == "circles"
          the_circle_members = Circle.find_by_id(@comment.comment_from).circle_members
        end

        the_circle_members.each do |member|
          unless member.user_id == @comment.user_id
            user = User.find(member.user_id)

            peck = Peck.create(user_id: user.id, institution_id: user.institution_id, notification_type: "circle_comment", message: the_message, send_push_notification: send_push_notification, invited_by: cparams[:user_id])

            send_notification(user, peck)
          end
        end
      end

      def update
        @comment = Comment.find(params[:id])
        @comment.update_attributes(comment_update_params)
      end

      def add_like
        @comment = Comment.find(params[:id])
        if params[:liker].to_i == auth[:user_id].to_i
          liker = User.find(params[:liker])
          liker.like!(@comment)
          @likers = @comment.likers(User)
          @likes = []
          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def unlike
        @comment = Comment.find(params[:id])
        if params[:unliker].to_i == auth[:user_id].to_i
          liker = User.find(params[:unliker])
          liker.unlike!(@comment)

          @likers = @comment.likers(User)
          @likes = []

          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def destroy
        @comment = Comment.find(params[:id]).destroy
      end

      private

        def comment_create_params(parameters)
          parameters.permit(:institution_id, :category, :comment_from, :user_id, :content)
        end

        def comment_update_params
          params.require(:comment).permit(:institution_id, :category, :comment_from, :user_id, :content)
        end
    end
  end
end
