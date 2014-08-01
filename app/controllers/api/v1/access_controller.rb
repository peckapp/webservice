module Api
  module V1

    class AccessController < ApplicationController

      # When you sign in, you get an authentication token.
      def create
        uparams = params[:user]

        # gets the udid from the user block
        the_udid = uparams.delete(:udid)
        the_token = uparams.delete(:device_token)
        # first authenticate user with email and password
        @user = User.authenticate(authentication_params(uparams)[:email], authentication_params(uparams)[:password])

        # if authenticated
        if @user

          # provide auth token, set it in database and set it in authentication params
          @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
          @user.save
          auth[:authentication_token] = @user.authentication_token

          # Send UDID when you log in.
          # @udid = UniqueDeviceIdentifier.where(udid: the_udid).first

          # if this udid has never been put in the databse, create one
          @udid = UniqueDeviceIdentifier.create(udid: the_udid, token: the_token)

          # touch little boys
          @user.unique_device_identifiers << @udid

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
