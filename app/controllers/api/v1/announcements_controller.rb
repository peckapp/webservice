module Api
  module V1
    class AnnouncementsController < ApplicationController

      before_action :confirm_logged_in, :only => [:create, :update, :destroy, :add_like, :unlike]
      respond_to :json

      ###### LIKES FOR ANNOUNCEMENTS NEED TO BE UPDATED TO BE LESS EXPENSIVE WITH DB CALLS ######
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

        # get all likers for the given announcement and initialize an
        # array to store them
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

        # update attributes
        @announcement.update_attributes(announcement_update_params)
      end

      # method for permitting users to "like" announcements
      def add_like

        @announcement = Announcement.find(params[:id])

        # liker must have same id as the user id of authentication params
        liker = User.find(params[:liker])
        if params[:liker].to_i == auth[:user_id].to_i

          # above user is added to the set of likers of this announcement
          liker.like!(@announcement)
          @likers = @announcement.likers(User)
          @likes = []

          # provide array of ids in json response
          @likers.each do |user|
            @likes << user.id
          end
        end

        #### Creates a Peck notification for likes ####

        # pecks for likes on an announcement
        user = User.find(@announcement.user_id)
        Peck.create(user_id: user.id, institution_id: user.institution_id, notification_type: "announcement_like", message: "#{liker.first_name} likes your announcement: #{@announcement.title}.")
      end

      # method for unliking announcements
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
          params.require(:announcement).permit(:title, :announcement_description, :institution_id, :user_id, :category, :poster_id, :public, :comment_count)
        end
    end
  end
end
