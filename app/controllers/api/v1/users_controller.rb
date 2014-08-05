module Api
  module V1
    class UsersController < ApplicationController

      before_action :confirm_minimal_access, except: [:create, :user_for_udid]
      before_action :confirm_logged_in, only: [:user_circles]

      respond_to :json

      def index
        @users = specific_index(User, params).where('users.first_name IS NOT NULL')
      end

      def show
        @user = specific_show(User, params[:id])
      end

      def user_circles
        @circles = User.find(params[:id]).circles

        # hash mapping circle id to array of its members for display in json
        @member_ids = {}

        @circles.each do |c|
          @member_ids[c.id] = CircleMember.where("circle_id" => c.id).where("accepted" => true).pluck(:user_id)
        end
      end

      def create
        @user = User.create

        if params[:udid]
          udid = UniqueDeviceIdentifier.create(udid: params[:udid])
          UdidUser.create(unique_device_identifier_id: udid.id, user_id: @user.id)
          @user.unique_device_identifiers << udid
        end

        logger.info "Created anonymous user with id: #{@user.id}"

        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      # either returns an existing user with matching udid
      # or creates new user
      def user_for_udid

        # see if udid exist in db
        the_udid = UniqueDeviceIdentifier.where(udid: params[:udid]).sorted.last

        if the_udid

          # date of creation of most recent user to use this device
          # most_recent = UdidUser.where(unique_device_identifier_id: the_udid.id)

          # most_recent = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => params[:udid]).maximum("unique_device_identifiers_users.updated_at")

          # ID of most recent user to use this device
          id = UdidUser.where(unique_device_identifier: the_udid.id).sorted.last.user_id
          # id = User.joins('LEFT OUTER JOIN unique_device_identifiers_users ON unique_device_identifiers_users.user_id = users.id').joins('LEFT OUTER JOIN unique_device_identifiers ON unique_device_identifiers_users.unique_device_identifier_id = unique_device_identifiers.id').where("unique_device_identifiers.udid" => params[:udid]).where("unique_device_identifiers_users.updated_at" => most_recent).first.id
          logger.info "Users, most recent user id: #{id}"
          # return that user
          @user = specific_show(User, id)

          # this user was already in db
          @user.newly_created_user = false
        else
          # create user and a udid in db and pair them up in join table
          udid = UniqueDeviceIdentifier.create(udid: params[:udid])
          @user = User.create
          @user.unique_device_identifiers << udid

          udid_user = UdidUser.create(unique_device_identifier_id: udid.id, user_id: @user.id)

          @user.newly_created_user = true
        end
        # start session as in normal creation
        session[:user_id] = @user.id
        session[:api_key] = @user.api_key
      end

      # user registration
      def super_create

        # params in the user block
        uparams = params[:user]

        # params for super creating with mass assignment.
        sign_up_params = user_signup_params

        @user = User.find(params[:id])

        if @user && params[:id].to_i == auth[:user_id].to_i
          # makes it necessary for to have a password and password confirmation.
          @user.enable_strict_validation = true

          # assigns the password and password_confirmation from the values in the user block of params.
          sign_up_params[:password] = uparams[:password]
          sign_up_params[:password_confirmation] = uparams[:password_confirmation]

          if @user.update_attributes(sign_up_params)
            @user.authentication_token = SecureRandom.hex(30)
            @user.save
            auth[:authentication_token] = @user.authentication_token
            logger.info "super_created user with id: #{@user.id}"
          else
            logger.warn "attempted to super_create user with id: #{@user.id} with invalid authentication sign_up_params"
          end
        else
          logger.warn "attempted to super_create user with non-existant id: #{@user.id}"
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
        def user_signup_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :blurb, :institution_id)
        end

        def user_update_params
          params.require(:user).permit(:first_name, :last_name, :blurb, :facebook_link, :active, :institution_id)
        end

        def password_update_params
          params.require(:user).require(:new_password).permit(:password, :password_confirmation)
        end
    end
  end
end
