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

        # gets the device token from the user block
        the_token = uparams.delete(:device_token)
        logger.info "Access, token: #{the_token}"

        # gets the device type, nil for apple and 'android' for android
        the_device_type = uparams.delete(:device_type)
        logger.info "Access, device_type: #{the_device_type}"

        # gets the facebook link in the case someone has logged in with fb before
        the_facebook_link = uparams.delete(:facebook_link)
        logger.info "Access, facebook_link: #{the_facebook_link}"

        # gets the facebook token in the case someone has logged in with fb before
        the_facebook_token = uparams.delete(:facebook_token)
        logger.info "Access, facebook_token: #{the_facebook_token}"

        # first authenticate user with email and password
        @user = User.authenticate(authentication_params(uparams)[:email], authentication_params(uparams)[:password])

        # if authenticated
        if @user

          # User's have to click on the confirmation email to actually login.
          if @user.active == false
            @response = 'Please complete your registration with the confirmation we sent to your email.'
            respond_to do |format|
              format.json { render json: @response, status: :bad_request }
            end
          end # end if user is active

          # if the user is trying to log in and has a fb link and fb token, then add to the user's attributes
          if the_facebook_link && the_facebook_token
            @user.update_attributes(facebook_link: the_facebook_link, facebook_token: the_facebook_token)
          end
          # provide auth token, set it in database and set it in authentication params
          @user.authentication_token = SecureRandom.hex(30) unless @user.authentication_token
          @user.save
          auth[:authentication_token] = @user.authentication_token

          if the_udid
            # Send UDID when you log in.
            @udid = UniqueDeviceIdentifier.where(udid: the_udid, device_type: the_device_type, token: the_token).first

            # the case where the udid given the values from params is nonexistant
            if !@udid
              if the_token
                @udid = UniqueDeviceIdentifier.create(udid: the_udid, token: the_token, device_type: the_device_type)
              else
                @udid = UniqueDeviceIdentifier.create(udid: the_udid, device_type: the_device_type)
              end

              UdidUser.create(unique_device_identifier_id: @udid.id, user_id: @user.id)
              @user.unique_device_identifiers << @udid
            else
              # touchup that timestamp

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
            # no udid is not okay because mobile devices are the only devices using peck.
            head :bad_request
            logger.warn 'user device tried to call create action on access without a udid'
          end
        else # else for: if @user

          # something went wrong: authentication failed so email and password don't match
          head :unprocessable_entity
          logger.warn 'failed to authenticate user for session creation'
        end
      end

      def logout
        the_udid = params[:udid]
        the_token = params[:device_token]
        the_device_type = params[:device_type]

        # find user who is logging out
        @user = User.find(session[:user_id])

        # Case where a user logs out, so he/she should not be the most recent user and thus should not receive push notifs.
        @udid = UniqueDeviceIdentifier.where(udid: the_udid, device_type: the_device_type, token: the_token).first
        @udid_user = UdidUser.where(unique_device_identifier_id: @udid.id, user_id: @user.id).first

        @udid.destroy
        @user.unique_device_identifiers.destroy(@udid)
        @udid_user.destroy

        # remove auth token from authentication params and database
        @user.authentication_token = nil

        # user's fb token is no longer in the database if they log out for security reasons.
        if @user.facebook_token
          @user.facebook_token = nil
        end

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
