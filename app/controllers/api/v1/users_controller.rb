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
          @member_ids[c.id] = CircleMember.where('circle_id' => c.id).where('accepted' => true).pluck(:user_id)
        end
      end

      def user_announcements
        # all announcements for the user
        @announcements = Announcement.where(user_id: params[:id])
      end

      def create
        if params[:udid]
          @user = User.create
          udid = UniqueDeviceIdentifier.current_or_create_new(udid: params[:udid], device_type: params[:device_type])
          UdidUser.current_or_create_new(unique_device_identifier_id: udid.id, user_id: @user.id)
          @user.unique_device_identifiers << udid

          logger.info "Created anonymous user with id: #{@user.id}"

          session[:user_id] = @user.id
          session[:api_key] = @user.api_key
        else
          head :bad_request
          logger.warn 'user device tried to call create action without a udid'
        end
      end

      # either returns an existing user with matching udid
      # or creates new user
      def user_for_udid
        if params[:udid]
          # see if udid exist in db
          the_udid = UniqueDeviceIdentifier.where(udid: params[:udid], device_type: params[:device_type]).sorted.last

          if the_udid

            # ID of most recent user to use this device
            id = UdidUser.where(unique_device_identifier: the_udid.id).sorted.last.user_id

            # return that user
            @user = specific_show(User, id)

            # this user was already in db
            @user.newly_created_user = false
          else
            # create user and a udid in db and pair them up in join table
            udid = UniqueDeviceIdentifier.create(udid: params[:udid], device_type: params[:device_type])
            @user = User.create
            @user.unique_device_identifiers << udid

            udid_user = UdidUser.create(unique_device_identifier_id: udid.id, user_id: @user.id)

            @user.newly_created_user = true
          end
          # start session as in normal creation
          session[:user_id] = @user.id
          session[:api_key] = @user.api_key
        else
          head :bad_request
          logger.warn "tried to not send a udid"
        end
      end

      # user registration
      def super_create

        # params in the user block
        uparams = params[:user]
        the_udid = uparams.delete(:udid)
        the_token = uparams.delete(:device_token)
        the_device_type = uparams.delete(:device_type)

        @user = User.find(params[:id])

        if @user && params[:id].to_i == auth[:user_id].to_i
          # makes it necessary for to have a password and password confirmation.
          @user.enable_strict_validation = true

          # assigns the password and password_confirmation from the values in the user block of params.
          user_signup_params(uparams)[:password] = uparams[:password]
          user_signup_params(uparams)[:password_confirmation] = uparams[:password_confirmation]

          active_user = User.where(email: uparams[:email], active: true).first
          if active_user
            if active_user.password_hash && active_user.password_salt
              head :unprocessable_entity
              logger.warn "tried to take the email of an already existing user"
              return
            else
              @user = active_user
            end
          end

          if @user.update_attributes(user_signup_params(uparams))
             @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
             @user.save
             auth[:authentication_token] = @user.authentication_token

            if the_udid
              # check if udid/device token is provided
               @udid = UniqueDeviceIdentifier.where(udid: the_udid, token: the_token, device_type: the_device_type).first

               if ! @udid
                 if the_token
                   @udid = UniqueDeviceIdentifier.create(udid: the_udid, token: the_token, device_type: the_device_type)
                 else
                   @udid = UniqueDeviceIdentifier.create(udid: the_udid, device_type: the_device_type)
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
             the_id = @user.id
             Communication::SendEmail.perform_async(the_id, nil)
             else
               head :bad_request
               logger.warn "tried to not send a udid"
             end
           else
             logger.warn "attempted to super_create user with id: #{@user.id} with invalid authentication sign_up_params"
           end
        else
          logger.warn "attempted to super_create user with non-existant id: #{@user.id}"
        end
      end

      def reset_password
        @user = User.where(email: params[:email]).first
        if @user
          Communication::PasswordReset.perform_async(@user.id)
        end
      end

      def facebook_login
        fb_params = params[:user]
        the_udid = fb_params.delete(:udid)
        the_token = fb_params.delete(:device_token)
        the_device_type = fb_params.delete(:device_type)
        send_confirmation_email = fb_params.delete(:send_email)
        fb_link = fb_params.delete(:facebook_link)

        @user = User.find(params[:id])

        if @user && params[:id].to_i == auth[:user_id].to_i

          # if the user already has an email that matches with their facebook college email
          user = User.where(facebook_link: fb_link, email: fb_params[:email]).first
          if user
            @user = user
            # if fb gave out an access token
            if fb_params[:facebook_token]
              # update the user and add their access token
              @user.update_attributes(facebook_token: fb_params[:facebook_token])

              # use the current one if they're logged in on another device
              @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
              @user.save
              auth[:authentication_token] = @user.authentication_token
            end
          else
            active_user = User.where(email: fb_params[:email], active: true).first
            if active_user
              @user = active_user
            end
            # Then the user has not logged in before
            @user.enable_facebook_validation = true
            if @user.update_attributes(facebook_login_params(fb_params))
              if active_user && send_confirmation_email
                head :unprocessable_entity
                logger.warn "tried to take the email of an already existing user"
              elsif send_confirmation_email
                @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
                @user.save
                auth[:authentication_token] = @user.authentication_token
                Communication::SendEmail.perform_async(@user.id, fb_link)
              else
                @user.update_attributes(active: true, facebook_link: fb_link, authentication_token: SecureRandom.hex(30))
                auth[:authentication_token] = @user.authentication_token
              end
            end
          end

          if @user.authentication_token

            if the_udid
              # check if udid/device token is provided
              @udid = UniqueDeviceIdentifier.where(udid: the_udid, token: the_token, device_type: the_device_type).first
              if ! @udid
                if the_token
                  @udid = UniqueDeviceIdentifier.create(udid: the_udid, token: the_token, device_type: the_device_type)
                else
                  @udid = UniqueDeviceIdentifier.create(udid: the_udid, device_type: the_device_type)
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
              head :bad_request
              logger.warn "tried to not send a udid"
            end
            logger.info "super_created user with id: #{@user.id}"
          else
            logger.warn "attempted to super_create user with id: #{@user.id} with invalid authentication sign_up_params"
          end
        else
          logger.warn "attempted to super_create user with non-existant id: #{@user.id}"
        end
      end

      def check_link
        uparams = params[:user]
        @user = User.where(facebook_link: uparams[:facebook_link]).first
        if @user && uparams[:facebook_link]
          @facebook_registered = true
        else
          @facebook_registered = false
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
        def user_signup_params(parameters)
          parameters.permit(:first_name, :last_name, :email, :password, :password_confirmation, :blurb, :institution_id)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :institution_id)
        end

        def facebook_login_params(parameters)
          parameters.permit(:first_name, :last_name, :email, :facebook_token, :institution_id)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
