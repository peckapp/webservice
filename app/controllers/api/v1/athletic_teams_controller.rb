module Api
  module V1
    class AthleticTeamsController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @athletic_teams = AthleticTeam.all
    end

    def show
      @athletic_team = AthleticTeam.find(params[:id])
    end

    def create
      @athletic_team = AthleticTeam.create(athletic_team_params)
    end

    def update
      @athletic_team = AthleticTeam.find(params[:id])
      @athletic_team.update_attributes(athletic_team_params)
    end

    def destroy
      @athletic_team = AthleticTeam.find(params[:id]).destroy
    end

    private

      def athletic_team_params
        params.require(:athletic_team).permit(:institution_id, :sport_name, :gender, :head_coach, :team_link, :created_at, :updated_at)
      end
    end
  end
end