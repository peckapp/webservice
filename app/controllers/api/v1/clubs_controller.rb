module Api
  module V1
    class ClubsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @clubs = Club.all
    end

    def show
      @club = Club.find(params[:id])
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
        params.require(:club).permit(:institution_id, :club_name, :description, :user_id, :created_at, :updated_at)
      end
    end
  end
end
