module Api
  module V1
    class CircleMembersController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in

      # give circle admin power?
      respond_to :json

      def index
        @circle_members = specific_index(CircleMember, params)
      end

      def create
        # removes unpermitted parameters from circle member creation params
        # and saves them in token and message vars
        member_create_params = params[:circle_member]
        token = member_create_params.delete(:token)
        message = member_create_params.delete(:message)

        @circle_member = CircleMember.create(circle_member_create_params(member_create_params))

        # push notification for circle member invite
        APNS.send_notification(token, alert: message, :other => {:circle_member_id => @circle_member.id})
      end

      # action for when pending circle member clicks accept to the invitation.
      def accept
        @circle_member = CircleMember.find(params[:id])
        @circle_member.update_attributes(:accepted => true)
      end

      def show
        @circle_member = specific_show(CircleMember, params[:id])
      end

      def update
        @circle_member = CircleMember.find(params[:id])
        @circle_member.update_attributes(circle_member_params)
      end

      def destroy
        circle_member_destroy_params = params[:circle_member]
        @circle_member = CircleMember.where(:user_id => circle_member_destroy_params[:user_id]).where(:circle_id => circle_member_destroy_params[:circle_id]).first.destroy
      end

      private

        def circle_member_create_params(parameters)
          parameters.permit(:institution_id, :user_id, :circle_id, :user_id, :invited_by, :date_added)
        end

        def circle_member_params
          params.require(:circle_member).permit(:institution_id, :circle_id, :user_id, :invited_by, :date_added)
        end
    end
  end
end
