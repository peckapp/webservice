module Api
  module V1
    class ClubsController < ApplicationController #Api::BaseController

      # :before_action => :confirm_admin
      # :except => [:index, :show]

      # give club admin power?
      respond_to :json

      def index
        @clubs = institution_index(Club)
      end

      def show
        @club = institution_show(Club)
      end

      def create
        @club = Club.create(club_params)
      end

      def update
        @club = Club.find(params[:id])
        @club.update_attributes(club_params)
      end

      def destroy
        @club = Club.find(params[:id]).destroy
      end

      private

        def club_params
          params.require(:club).permit(:institution_id, :club_name, :description, :user_id)
        end
    end
  end
end
