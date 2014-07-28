module Api
  module V1
    class AnnouncementsController < ApplicationController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy, :add_like]
      respond_to :json

      def index
        @announcements = specific_index(Announcement, params)

        # for each announcement

      def show
        @announcement = specific_show(Announcement, params[:id])
        @likers = @announcement.likers(User)
        @likes = []
        if @likers
          # display the first and last name of all the likers
          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def create
        announcement_create_params = announcement_params

        # gets the image from the params
        announcement_create_params[:image] = params[:image]

        @announcement = Announcement.create(announcement_create_params)
      end

      def update
        @announcement = Announcement.find(params[:id])
        announcement_update_params = announcement_params

        # gets the image from the params
        announcement_update_params[:image] = params[:image]
        @announcement.update_attributes(announcement_update_params)
      end

      def add_like
        @announcement = Announcement.find(params[:id])
        # liker must be the same as the user id of authentication params
        if params[:liker].to_i == auth[:user_id].to_i
          liker = User.find(params[:liker])

          # the person with the passed id likes this announcement
          liker.like!(@announcement)
          @likers = @announcement.likers(User)
          @likes = []

          # display the first and last name of all the likers
          @likers.each do |user|
            @likes << user.id
          end
        end
      end

      def destroy
        @announcement = Announcement.find(params[:id]).destroy
      end

      private

        def announcement_params
          params.require(:announcement).permit(:title, :announcement_description, :institution_id, :user_id, :department_id, :club_id, :circle_id, :public, :comment_count)
        end
    end
  end
end
