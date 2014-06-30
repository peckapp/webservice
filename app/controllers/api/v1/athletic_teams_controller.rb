module Api
  module V1
    class AthleticTeamsController < ApplicationController #Api::BaseController

      # before_action => :confirm_admin
      # :except => [:index, :show]

      respond_to :json

<<<<<<< HEAD
    def index
      @athletic_teams = institution_index(AthleticTeam)
    end
    
    def show
      @athletic_team = institution_show(AthleticTeam)
    end
=======
      def index
        @athletic_teams = institution_index(AthleticTeam)
      end

      def show
        @athletic_team = institution_show(AthleticTeam)
      end
>>>>>>> 2e96ec34a63448eb9af096b20702efa0a79fc92c

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
