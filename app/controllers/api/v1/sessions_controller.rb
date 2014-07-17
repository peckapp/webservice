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

      # set after you press the button confirming which institution to view while not logged in.
      def set_public
        session[:institution_id] = params[:institution_id]

        
        unless session[:user_id]
          session[:user_id] = params[:user_id]
        end
        # unless session[:user_id] || User.where(:api_key => params[:api_key]).first
        #   session[:api_key] = params[:api_key]
        # end
      end

      # after you scroll in the institution selection screen
      def switch_institution
        session[:institution_id] = nil
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
