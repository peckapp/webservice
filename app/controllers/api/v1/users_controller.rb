module Api
  module V1
    class UsersController < ApplicationController #Api::BaseController

      before_action :confirm_minimal_access, :except => [:create, :user_for_device_token]

      respond_to :json

      def index
        @users = specific_index(User, params).where("users.first_name IS NOT NULL")
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def user_circles
        @circles = User.find(params[:id]).circles

        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        for c in @circles
          @member_ids[c.id] = CircleMember.where("circle_id" => c.id).pluck(:user_id)
        end
      end

      def create
        @user = User.create

        if params[:user_device_token]
          token = UserDeviceToken.create(:token => params[:user_device_token])
          @user.user_device_tokens << token
        end

        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      # either returns an existing user with matching token
      # or creates new user
      def user_for_device_token

        # see if token exist in db
        the_token = UserDeviceToken.where(:token => params[:user_device_token]).first

        if the_token

          # date of creation of most recent user to use this device
          most_recent = User.joins('LEFT OUTER JOIN user_device_tokens_users ON user_device_tokens_users.user_id = users.id').joins('LEFT OUTER JOIN user_device_tokens ON user_device_tokens_users.user_device_token_id = user_device_tokens.id').where("user_device_tokens.token" => params[:user_device_token]).maximum("user_device_tokens_users.created_at")

          # ID of most recent user to use this device
          id = User.joins('LEFT OUTER JOIN user_device_tokens_users ON user_device_tokens_users.user_id = users.id').joins('LEFT OUTER JOIN user_device_tokens ON user_device_tokens_users.user_device_token_id = user_device_tokens.id').where("user_device_tokens.token" => params[:user_device_token]).where("user_device_tokens_users.created_at" => most_recent).first.id

          # return that user
          @user = specific_show(User, id)

          # this user was already in db
          @user.newly_created_user = false
        else
          # create user and a token in db and pair them up in join table
          token = UserDeviceToken.create(:token => params[:user_device_token])
          @user = User.create
          @user.user_device_tokens << token
          @user.newly_created_user = true
        end
        # start session as in normal creation
        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
        @user.save
      end

      # user registration
      def super_create

        # params in the user block
        uparams = params[:user]

        # params for super creating with mass assignment.
        sign_up_params = user_signup_params

        @user = User.find(params[:id])

        if @user
          # makes it necessary for to have a password and password confirmation.
          @user.enable_strict_validation = true

          # assigns the password and password_confirmation from the values in the user block of params.
          sign_up_params[:password] = uparams[:password]
          sign_up_params[:password_confirmation] = uparams[:password_confirmation]

          if @user.update_attributes(sign_up_params)
            @user.authentication_token = SecureRandom.hex(30)
            @user.save
            auth[:authentication_token] = @user.authentication_token
          end
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
        else
          @user = User.find(session[:user_id])
          @user.old_pass_match = false
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
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :blurb)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
