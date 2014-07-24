module Api
  module V1
    class AthleticTeamsController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!, :only => [:create, :update, :destroy]
      # before_action => :confirm_admin, :only => [:create, :update, :destroy]

      respond_to :json

    def index
      @athletic_teams = specific_index(AthleticTeam, params)
    end

    def show
      @athletic_team = specific_show(AthleticTeam, params[:id])
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
          params.require(:athletic_team).permit(:institution_id, :sport_name, :gender, :head_coach, :team_link)
        end
    end
  end
end
