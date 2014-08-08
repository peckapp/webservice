module Api
  module V1
    # controls login access to the api
    class AccessController < ApplicationController
      # When you sign in, you get an authentication token.
      def create
        uparams = params[:user]

        # gets the udid from the user block
        the_udid = uparams.delete(:udid)
        logger.info "Access, udid: #{the_udid}"

        # if little john provides a device token
        if uparams[:device_token]
          the_token = uparams.delete(:device_token)
          logger.info "Access, token: #{the_token}"
        end

        # first authenticate user with email and password
        @user = User.authenticate(authentication_params(uparams)[:email], authentication_params(uparams)[:password])

        # if authenticated
        if @user

          # provide auth token, set it in database and set it in authentication params
          @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
          @user.save
          auth[:authentication_token] = @user.authentication_token

          # Send UDID when you log in.
          @udid = UniqueDeviceIdentifier.where(udid: the_udid).first

          if !@udid
            if the_token
              @udid = UniqueDeviceIdentifier.create(udid: the_udid, token: the_token)
            else
              @udid = UniqueDeviceIdentifier.create(udid: the_udid)
            end

            UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
            @user.unique_device_identifiers << @udid
          else
            # touch little boys
            @udid.touch

            @udid_user = UdidUser.where(unique_device_identifier_id: @udid.id, user_id: @user.id).first
            if @udid_user
              # update the timestamp if the udid_user already exists
              @udid_user.touch
            else
              @udid_user = UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
            end
          end
          logger.info "created session for user with id: #{@user.id}"
        else

          # something went wrong
          head :bad_request
          logger.warn "failed to authenticate user for session creation"
        end
      end

      def logout
        # find user who is logging out
        @user = User.find(session[:user_id])

        # remove auth token from authentication params and database
        @user.authentication_token = nil
        @user.save

        logger.info "destroyed session for user with id: #{@user.id}"
      end

      private
        def authentication_params(user_params)
          user_params.permit(:email, :password)
        end
    end
  end
end
