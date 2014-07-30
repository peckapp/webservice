module Api
  module V1

    class AccessController < ApplicationController

      # When you sign in, you get an authentication token.
      def create

        # first authenticate user with email and password
        @user = User.authenticate(authentication_params[:email], authentication_params[:password])

        # if authenticated
        if @user

          # provide auth token, set it in database and set it in authentication params
          @user.authentication_token = SecureRandom.hex(30)
          @user.save
          auth[:authentication_token] = @user.authentication_token
          @user_device_token = @user.user_device_tokens.first
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

        def authentication_params
          params.require(:user).permit(:email, :password)
        end

    end
  end
end
