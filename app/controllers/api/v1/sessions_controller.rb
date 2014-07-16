module Api
  module V1
    class SessionsController < ApplicationController

      def create
        @user = User.authenticate(params[:email], params[:password])

        session[:institution_id] = params[:institution_id]
        if @user
          session[:user_id] = @user.id
        end
      end

      def destroy
        session[:user_id] = nil
        session[:institution_id] = nil
      end
    end
  end
end
