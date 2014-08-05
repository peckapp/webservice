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
        peck_create_params = params[:peck]
        # token = peck_create_params.delete(:token)

        @all_pecks = []
        @peck_dict = {}

        #### Circle Invite ####
        if peck_create_params[:notification_type] == "circle_invite"
          circle = peck_create_params.delete(:circle_id)
          user = User.find(peck_create_params[:user_id])

          # create a circle member
          circle_member = CircleMember.create(user_id: peck_create_params[:user_id], institution_id: peck_create_params[:institution_id], circle_id: circle, invited_by: peck_create_params[:invited_by])

          # set the invitation to match the id of the circle member
          peck_create_params[:invitation] = circle_member.id

          # add the circle member to the array of circle members for the user
          user.circle_members << circle_member

          # create the peck with these attributes
          peck = Peck.create(peck_params(peck_create_params))

          @all_pecks << peck
          # for each of the user's udids
          user.unique_device_identifiers.each do |device|

            # date of creation of most recent user to use this device
            udid_id = UniqueDeviceIdentifier.where(udid: device.udid).sorted.last.id

            logger.info "Pecks, most recent: #{most_recent}"

            # ID of most recent user to use this device
            uid = UdidUser.where(unique_device_identifier: udid_id).sorted.last.user_id
            logger.info "Pecks, uid: #{uid}"
            logger.info "Pecks, user id: #{user.id}"

            # the token for the udid
            the_token = device.token
            logger.info "Pecks, the token: #{the_token}"
            # as long as the token is not nil and the user is the most recent user
            if user.id == uid && the_token
              @peck_dict[the_token] = peck
            end
          end
        end


        # if the peck is meant to be a push notification, then send it.
        @peck_dict.each do |token, peck|
          if peck.send_push_notification
            APNS.send_notification(token, alert: peck.message, badge: 1, sound: 'default')
          end
        end
      end

      def update
        @peck = Peck.find(params[:id])
        @peck.update_attributes(peck_update_params)
      end

      def destroy
        @peck = Peck.find(params[:id]).destroy
      end

      private
        def peck_params(parameters)
          parameters.permit(:user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :invitation)
        end

        def peck_update_params
          params.require(:peck).permit(:user_id, :institution_id, :notification_type, :message, :send_push_notification, :invited_by, :invitation)
        end
    end
  end
end
