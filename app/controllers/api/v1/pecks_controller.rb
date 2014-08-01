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
        @peck = Peck.create(peck_params)
      end

      def update
        @peck = Peck.find(params[:id])
        @peck.update_attributes(peck_params)
      end

      def destroy
        @peck = Peck.find(params[:id]).destroy
      end

      private
        def peck_params
          params.require(:peck).permit(:user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by)
        end
    end
  end
end
