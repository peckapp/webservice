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
        event_members = peck_create_params.delete(:event_member_ids) if peck_create_params[:event_member_ids]

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
            most_recent = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).maximum("unique_device_identifiers_users.updated_at")

            # ID of most recent user to use this device
            uid = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).where("unique_device_identifiers_users.updated_at" => most_recent).first.id

            # the token for the udid
            the_token = device.token

            # as long as the token is not nil and the user is the most recent user
            if user.id == uid && the_token
              @peck_dict[the_token] = peck
            else
              # otherwise set token to 'no token' for clarity
              the_token = "no token"
              @peck_dict[the_token] = peck
            end
          end
        end

        #### Event Invite ####
        if peck_create_params[:notification_type] == "event_invite" && event_members

          # from the array of user ids
          event_members.each do |member_id|
            user = User.find(member_id)

            # create a peck for that user
            peck = Peck.create(user_id: user.id, institution_id: user.institution_id, notification_type: "event_invite", message: peck_create_params[:message], send_push_notification: peck_create_params[:send_push_notification], invited_by: peck_create_params[:invited_by], invitation: peck_create_params[:event_id])

            @all_pecks << peck
            # for each of the users udids
            user.unique_device_identifiers.each do |device|

              # date of creation of most recent user to use this device
              most_recent = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).maximum("unique_device_identifiers_users.updated_at")

              # ID of most recent user to use this device
              uid = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).where("unique_device_identifiers_users.updated_at" => most_recent).first.id

              # token for this udid
              the_token = device.token

              # as long as the token is not nil and the user is the most recent user
              if user.id == uid && the_token
                @peck_dict[the_token] = peck
              else
                # otherwise set token to 'no token' for clarity
                the_token = "no token"
                @peck_dict[the_token] = peck
              end
            end
          end
        end


        # if the peck is meant to be a push notification, then send it.
        @peck_dict.each do |token, peck|
          if peck.send_push_notification && token != "no token"
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
