module Api
  module V1
    class CircleMembersController < ApplicationController #Api::BaseController

    # before_action :confirm_logged_in
    # :except => [:index, :show]

     # give circle admin power?
    respond_to :json

    def index
      if params[:circle_id]
        @circle_members = CircleMember.where(:circle_id => params[:circle_id])
      else
        @circle_members = CircleMember.all
      end
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
        params.require(:circle_member).permit(:circle_id, :user_id, :invited_by, :date_added)
      end
    end
  end
end
