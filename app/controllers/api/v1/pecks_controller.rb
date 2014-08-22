module Api
  module V1
    class PecksController < ApplicationController #Api::BaseController

      # before_action :authenticate_admin_user!
      # before_action :confirm_admin

      respond_to :json

      def index
        @pecks = specific_index(Peck, params)
      end

      def show
        @peck = specific_show(Peck, params[:id])
      end

      def create
        @peck = Peck.create(peck_create_params)
      end

      def destroy
        @peck = Peck.find(params[:id])

        if @peck.notification_type == 'circle_invite'
          member = CircleMember.find(@peck.refers_to)
          member.destroy unless member.accepted
        end

        @peck.destroy
      end

      private
        def peck_create_params
          params.require(:peck).permit(:user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :invitation)
        end

        def peck_update_params
          params.require(:peck).permit(:user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :invitation, :interacted)
        end
    end
  end
end
