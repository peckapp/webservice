module Api
  module V1
    class UsersController < ApplicationController

      before_action :confirm_minimal_access, except: [:create, :user_for_udid]
      before_action :confirm_logged_in, only: [:user_circles, :user_announcements]

      respond_to :json

      def index
        @users = specific_index(User, params).where('users.first_name IS NOT NULL')
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def user_circles

        # only circles where the user has accepted the invite for should be visible
        circle_members = CircleMember.where(accepted: true, user_id: params[:id])
        @circles = []
        circle_members.each do |member|
          the_circle = Circle.find(member.circle_id)
          @circles << the_circle
        end


        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        @circles.each do |c|
          @member_ids[c.id] = CircleMember.where("circle_id" => c.id).where("accepted" => true).pluck(:user_id)
        end
      end

      def user_announcements
        # all announcements for the user
        @announcements = Announcement.where(user_id: params[:id])
      end

      def create
        @user = User.create

        if params[:udid]
          udid = UniqueDeviceIdentifier.create(udid: params[:udid])
          UdidUser.create(unique_device_identifier_id: udid.id, user_id: @user.id)
          @user.unique_device_identifiers << udid
        end

        logger.info "Created anonymous user with id: #{@user.id}"

        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      # either returns an existing user with matching udid
      # or creates new user
      def user_for_udid

        # see if udid exist in db
        the_udid = UniqueDeviceIdentifier.where(udid: params[:udid]).sorted.last

        if the_udid

          # ID of most recent user to use this device
          id = UdidUser.where(unique_device_identifier: the_udid.id).sorted.last.user_id

          # return that user
          @user = specific_show(User, id)

          # this user was already in db
          @user.newly_created_user = false
        else
          # create user and a udid in db and pair them up in join table
          udid = UniqueDeviceIdentifier.create(udid: params[:udid])
          @user = User.create
          @user.unique_device_identifiers << udid

          udid_user = UdidUser.create(unique_device_identifier_id: udid.id, user_id: @user.id)

          @user.newly_created_user = true
        end
        # start session as in normal creation
        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      # user registration
      def super_create

        # params in the user block
        uparams = params[:user]

        # params for super creating with mass assignment.
        sign_up_params = user_signup_params

        @user = User.find(params[:id])

        if @user && params[:id].to_i == auth[:user_id].to_i
          # makes it necessary for to have a password and password confirmation.
          @user.enable_strict_validation = true

          # assigns the password and password_confirmation from the values in the user block of params.
          sign_up_params[:password] = uparams[:password]
          sign_up_params[:password_confirmation] = uparams[:password_confirmation]

          if @user.update_attributes(sign_up_params)
            @user.authentication_token = SecureRandom.hex(30)
            @user.save
            auth[:authentication_token] = @user.authentication_token
            logger.info "super_created user with id: #{@user.id}"

            # check if udid/device token is provided
            @udid = UniqueDeviceIdentifier.where(udid: uparams[:udid]).first

            if ! @udid
              if uparams[:device_token]
                @udid = UniqueDeviceIdentifier.create(udid: uparams[:udid], token: uparams[:device_token])
              else
                @udid = UniqueDeviceIdentifier.create(udid: uparams[:udid])
              end

              UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
              @user.unique_device_identifiers << @udid

            else

              @udid.touch

              @udid_user = UdidUser.where(unique_device_identifier_id: @udid.id, user_id: @user.id).first
              if @udid_user
                # update the timestamp if the udid_user already exists
                @udid_user.touch
              else
                @udid_user = UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
              end
            end
          else
            logger.warn "attempted to super_create user with id: #{@user.id} with invalid authentication sign_up_params"
          end
        else
          logger.warn "attempted to super_create user with non-existant id: #{@user.id}"
        end
      end

      def facebook_login
        fb_params = params[:facebook]
        @user = User.find(params[:id])

        if @user && params[:id].to_i == auth[:user_id].to_i

          # if the user already has an email that matches with their facebook college email
          if @user.email == fb_params[:email]

            # if fb gave out an access token
            if fb_params[:access_token]

              # update the user and add their access token
              @user.update_attributes(facebook_token: fb_params[:access_token])

              # use the current one if they're logged in on another device
              @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
              @user.save
              auth[:authentication_token] = @user.authentication_token
            end
          else

            # Then the user has not logged in before
            @user.enable_facebook_validation = true
            if @user.update_attributes(facebook_login_params)
               @user.authentication_token = SecureRandom.hex(30)
               @user.save
               auth[:authentication_token] = @user.authentication_token
            end
          end

          if @user.authentication_token
            # check if udid/device token is provided
            @udid = UniqueDeviceIdentifier.where(udid: uparams[:udid]).first
            if ! @udid
              if uparams[:device_token]
                @udid = UniqueDeviceIdentifier.create(udid: uparams[:udid], token: uparams[:device_token])
              else
                @udid = UniqueDeviceIdentifier.create(udid: uparams[:udid])
              end

              UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
              @user.unique_device_identifiers << @udid

            else
              @udid.touch

              @udid_user = UdidUser.where(unique_device_identifier_id: @udid.id, user_id: @user.id).first
              if @udid_user
                  # update the timestamp if the udid_user already exists
                @udid_user.touch
              else
                @udid_user = UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
              end
            end
          else
            logger.warn "attempted to super_create user with id: #{@user.id} with invalid authentication sign_up_params"
          end
        else
          logger.warn "attempted to super_create user with non-existant id: #{@user.id}"
        end
      end

      def update
        if params[:id].to_i == auth[:user_id].to_i
          @user = User.find(params[:id])
          update_params = user_update_params

          # gets the image from the params
          update_params[:image] = params[:image]
          @user.update_attributes(update_params)
        else
          head :unauthorized
        end
      end

      def change_password
        # password and password confirmation
        new_pass_params = password_update_params

        # authenticate based on the password provided in the old password field
        @user = User.authenticate(User.find(session[:user_id]).email, params[:user][:password])

        if @user
          # old_pass_match used as boolean for correct JSON response
          @user.old_pass_match = true
          @user.update_attributes(new_pass_params)

          logger.info "sucessfully updated password for user with id: #{@user.id}"
        else
          @user = User.find(session[:user_id])
          @user.old_pass_match = false

          logger.warn "failed authentication for updating password for user with id: #{@user.id}"
        end
      end

      def destroy
        if params[:id].to_i == auth[:user_id].to_i
          @user = User.find(params[:id]).destroy
        else
          head :unauthorized
        end
      end

      private
        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :blurb, :institution_id)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active, :institution_id)
        end

        def facebook_login_params
          params.require(:user).permit(:first_name, :last_name, :email, :facebook_link, :facebook_token, :active, :institution_id)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
