module Api
  module V1
    class AnnouncementsController < ApplicationController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy, :add_like]
      respond_to :json

      def index
        @announcements = specific_index(Announcement, params)

        # dictionary for the likes per announcement
        @likes_for_announcement = {}

        # for each announcement
        @announcements.each do |announcement|
          likers = []

          # for each liker in the array of announcement likers, add the user's id
          announcement.likers(User).each do |user|
            likers << user.id
          end

          @likes_for_announcement[announcement] = likers
        end
      end


      def show
        @announcement = specific_show(Announcement, params[:id])
        @likers = @announcement.likers(User)
        @likes = []

        # if there are likers, then return the ids of each liker
        if @likers
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

      def unlike
        @announcement = Announcement.find(params[:id])
        if params[:unliker].to_i == auth[:user_id].to_i
          liker = User.find(params[:unliker])
          liker.unlike!(@announcement)

          @likers = @announcement.likers(User)
          @likes = []

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
