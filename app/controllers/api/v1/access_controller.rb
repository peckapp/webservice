module Api
  module V1

    class AccessController < ApplicationController

      # When you sign in, you get an authentication token.
      def create
        uparams = params[:user]

        # gets the udid from the user block
        the_udid = uparams.delete(:udid)
        # first authenticate user with email and password
        @user = User.authenticate(authentication_params(uparams)[:email], authentication_params(uparams)[:password])

        # if authenticated
        if @user

          # provide auth token, set it in database and set it in authentication params
          @user.authentication_token = SecureRandom.hex(30)
          @user.save
          auth[:authentication_token] = @user.authentication_token

          # Send UDID when you log in.
          @udid = UniqueDeviceIdentifier.where(udid: the_udid).first

          # if this udid has never been put in the databse, create one
          if ! @udid
            @udid = UniqueDeviceIdentifier.create(udid: the_udid)
          end

          # add the udid to the udids for the user unless it's already one of the user's udids.
          @user.unique_device_identifiers << @udid unless check_udid(@user, the_udid)
          
          logger.info "created session for user with id: #{@user.id}"
        else

          # something went wrong
          head :bad_request
          logger.warn "failed to authenticate user for session creation"
        end
      end

      def destroy

        # find user who is logging out
        @user = User.find(session[:user_id])

        # remove auth token from authentication params and database
        auth[:authentication_token] = nil
        @user.authentication_token = nil
        @user.save

        logger.info "destroyed session for user with id: #{@user.id}"
      end

      private

        def check_udid(user, udid_param)
          return user.unique_device_identifiers.where(udid: udid_param).first
        end

        def authentication_params(user_params)
          user_params.permit(:email, :password)
        end
    end
  end
end
