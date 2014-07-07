module Api
  module V1
    class CircleMembersController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      # give circle admin power?
      respond_to :json


      def index
        @circle_members = specific_index(CircleMember, params)
      end

      def create
        @circle_member = CircleMember.create(circle_member_params)
      end

      def show
        @circle_member = specific_show(CircleMember, params[:id])
      end

      def update
        @circle_member = CircleMember.find(params[:id])
        @circle_member.update_attributes(circle_member_params)
      end

      def destroy
        @circle_member = CircleMember.find(params[:id]).destroy
      end

      private

        def circle_member_params
          params.require(:circle_member).permit(:institution_id, :circle_id, :user_id, :invited_by, :date_added)
        end
    end
  end
end
