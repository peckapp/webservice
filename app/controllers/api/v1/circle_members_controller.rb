module Api
  module V1
    class CircleMembersController < ApplicationController #Api::BaseController

    respond_to :json

    def index
      @circle_members = CircleMember.all
    end

    def show
      @circle_member = CircleMember.find(params[:id])
    end

    def create
      @circle_member = CircleMember.create(circle_member_params)
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
        params.require(:circle_member).permit(:circle_id, :user_id, :invited_by, :date_added, :created_at, :updated_at)
      end
    end
  end
end
