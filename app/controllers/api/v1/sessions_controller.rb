module Api
  module V1
    class SessionsController < ApplicationController

      # When you sign in, you get an authentication token.
      def create
        @user = User.authenticate(params[:email], params[:password])
        if @user

          # authentication token randomly generated each time signed in
          session[:authentication_token] = SecureRandom.hex(20)

          # params for the authentication token are equal to the session's.
          params[:authentication_token] = session[:authentication_token]
        end
      end

      def destroy
        @user = User.find(session[:user_id])
        session[:user_id] = nil
        # session[:authentication_token] = nil
        session[:authentication_token] = nil
        params[:authentication_token] = nil
      end
    end
  end
end
