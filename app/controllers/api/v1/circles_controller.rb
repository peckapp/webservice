module Api
  module V1
    class CirclesController < ApplicationController #Api::BaseController

      before_action :confirm_logged_in

      # give circle admin power?
      respond_to :json

      def index

        @circles = specific_index(Circle, params)

        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        for c in @circles
          @member_ids[c.id] = CircleMember.where("circle_id" => c.id).pluck(:user_id)
        end
      end

      def show
        @circle = specific_show(Circle, params[:id])

        # array of this circle's members for display in json
        @member_ids = CircleMember.where("circle_id" => params[:id]).pluck(:user_id)
      end

      def create
        # all of the parameters in the circle
        cparams = params[:circle]

        # returns the array of circle member ids
        the_circle_members = cparams.delete(:circle_member_ids)
        the_message = cparams.delete(:message)

        # passes in the cparams to permit certain attributes
        @circle = Circle.create(circle_create_params(cparams))

        @member_ids = []

        if @circle
          @creator = CircleMember.create(:accepted => true, :user_id => @circle.user_id, :circle_id => @circle.id, :institution_id => @circle.institution_id, :invited_by => @circle.user_id)

          @circle.circle_members << @creator
          # takes the array of circle members found in the circle block
          members = the_circle_members
          # members should be an array of integers corresponding to user ids
          members.each do |mem_id|
          # creates a circle member
            member = CircleMember.create(:institution_id => @circle.institution_id, :circle_id => @circle.id, :user_id => mem_id, :invited_by => @circle.user_id)

            the_user = User.find(mem_id)
            # the creator must always have an accepted tag of true.

            puts "Circles, current user: #{the_user}"
            puts "Circles, current user id: #{the_user.id}"
            puts "Circles, current mem id: #{mem_id}"
            # adds the member to the array of circle members for the created circle
            @circle.circle_members << member

            ### Push Notification Stuff ###

            # As long as the user is not the creator.
              # create a peck for the user in the passed array
              Peck.create(user_id: mem_id, institution_id: @circle.institution_id, notification_type: "circle_invite", message: the_message, invited_by: @circle.user_id, invitation: member.id)
              the_user.unique_device_identifiers.each do |device|
                puts "Circles, unique device identifiers: #{the_user.unique_device_identifiers}"
                puts "Circles, current udid: #{device.udid}"
                # date of creation of most recent user to use this device
                most_recent = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).maximum("unique_device_identifiers_users.updated_at")

                # ID of most recent user to use this device
                uid = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => device.udid).where("unique_device_identifiers_users.updated_at" => most_recent).first.id
                bob = UniqueDeviceIdentifier.where(udid: device.udid).where(token: device.token)
                if the_user.id == uid
                  puts "Circles, device token: #{device.token}"
                  APNS.send_notification(device.token, alert: the_message, badge: 1, sound: 'default')
                end
              end
            end

          # circle members
          circle_mems = @circle.circle_members

          circle_mems.each do |mem|
            @member_ids << mem.user_id
          end
        else
          @member_ids = nil
        end

        return @member_ids
      end

      def update
        @circle = Circle.find(params[:id])
        @circle.update_attributes(circle_update_params)
      end

      def destroy
        @circle = Circle.find(params[:id]).destroy
      end

      private

        def circle_create_params(parameters)
          parameters.permit(:institution_id, :user_id, :circle_name)
        end

        def circle_update_params
          params.require(:circle).permit(:institution_id, :user_id, :circle_name)
        end
    end
  end
end
