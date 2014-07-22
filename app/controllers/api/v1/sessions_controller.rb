module Api
  module V1
    class SessionsController < ApplicationController

      # When you sign in, you get an authentication token.
      def create
        @user = User.authenticate(params[:email], params[:password])
        # if @user
        #   @user.authentication_token = SecureRandom.hex(20)
        #   @user.save
        # end
      end

      def destroy
        session[:user_id] = nil
        @user.authentication_token = nil
        @user.save
      end
    end
  end
end
