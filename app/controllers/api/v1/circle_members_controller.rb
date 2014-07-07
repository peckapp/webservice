module Api
  module V1
    class CircleMembersController < ApplicationController #Api::BaseController

      # before_action :confirm_logged_in
      # :except => [:index, :show]

      # give circle admin power?
      respond_to :json


      def index

        puts "params: #{params}"

        if params[:circle_id]
          @circle_members = specific_index(CircleMember, circle_id: params[:circle_id])
          # filter circle members by institution id
        elsif params[:institution_id]
          @circle_members = CircleMember.joins(:circle).where("circles.institution_id" => params[:institution_id])
        else
            # otherwise return all circle members
          @circle_members = CircleMember.all
        end
      end

      def create
        @circle_member = CircleMember.create(circle_member_params)
      end

      def show
        if params[:circle_id]
          @circle_member = specific_show(Circle, :circle_id)
        elsif params[:institution_id]
          @circle_member = CircleMember.joins(:circle).where("circles.institution_id" => params[:institution_id]).find(params[:id])
        else
          @circle_member = CircleMember.find(params[:id])
        end
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
