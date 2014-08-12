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
        member_create_params = params[:circle_member]
        the_message = member_create_params.delete(:message)
        send_push_notification = member_create_params.delete(:send_push_notification)

        # create a circle member
        @circle_member = CircleMember.create(circle_member_create_params(member_create_params))

        # add the circle member to the array of circle members for the user
        user = User.find(@circle_member.user_id)
        user.circle_members << @circle_member

        # create the peck with these attributes
        peck = Peck.create(user_id: @circle_member.user_id, institution_id: @circle_member.institution_id, notification_type: "circle_invite", message: the_message, send_push_notification: send_push_notification, invited_by: @circle_member.invited_by, invitation: @circle_member.id )

        notify(user, peck)
      end

      # action for when pending circle member clicks accept to the invitation.
      def accept
        @circle_member = CircleMember.find(params[:id])
        @circle_member.update_attributes(accepted: true)

        @peck = Peck.find(params[:peck_id])

        @peck.update_attributes(interacted: true)
      end

      def show
        @circle_member = specific_show(CircleMember, params[:id])
      end

      def update
        @circle_member = CircleMember.find(params[:id])
        @circle_member.update_attributes(circle_member_update_params)
      end

      def destroy
        @circle_member = CircleMember.find(params[:id])
        circle = Circle.find(@circle_member.circle_id)
        circle.circle_members.destroy(@circle_member)
        @circle_member.destroy

        @peck = Peck.find(params[:peck_id])
        @peck.update_attributes(interacted: true)
      end

      def leave_circle
        circle_member_destroy_params = params[:circle_member]
        @circle_member = CircleMember.where(:user_id => circle_member_destroy_params[:user_id]).where(:circle_id => circle_member_destroy_params[:circle_id]).first.destroy
      end

      private

        def circle_member_create_params(parameters)
          parameters.permit(:institution_id, :user_id, :circle_id, :user_id, :invited_by, :date_added)
        end

        def circle_member_update_params
          params.require(:circle_member).permit(:institution_id, :circle_id, :user_id, :invited_by, :date_added)
        end
    end
  end
end
