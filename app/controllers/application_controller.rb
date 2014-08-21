# contains code that applies to all the classes which subclass it, including all the API controllers
# enforces security mechanisms for everything unless specified otherwise
class ApplicationController < ActionController::Base
  # allows all classes to inherit
  # before_action :confirm_minimal_access

  def confirm_logged_in
    # user is found by session id
    user = User.find(session[:user_id])
    # the auth token must be present
    if auth[:authentication_token] && auth[:authentication_token] == user.authentication_token && user.active
      return true
    else
      head :unauthorized
      return false
    end
  end

  def confirm_minimal_access
    if auth_params_exist
      # check validity of existing session: params not nil and are equal to the current session's
      if session[:user_id] && session[:api_key] && session[:user_id] == auth[:user_id] && session[:api_key] == auth[:api_key]
        return true
      else
        # otherwise attempts to create session for that user
        user = User.find(auth[:user_id])
        unless user.blank?
          # checks validity of api_key
          if user.api_key == auth[:api_key]

            # create session for existing user
            session[:user_id] = user.id
            session[:api_key] = user.api_key
            return true
          else
            # Invalid api key
            logger.warn "Attempted to confirm minimal access for user id: [#{user.id}] with invalid api key: [#{user.api_key}]"
          end
        end
      end
      head :unauthorized
      return false
    else
      head :unauthorized
    end
  end

  def specific_index(model, params_hash)
    search_params = model_search_params(model, params_hash)

    # uses authentication institution_id to get initial set
    # result = allowed_model_instances(model, params[:authentication])
    result = model.all # where(:institution_id => auth[:institution_id])

    # if there is at least one parameter, filter result
    unless search_params.blank?
      search_params.each do |p|
        result = result.where(p => params[p]) if params[p]
      end
    end

    result
  end

  # show instance of model
  def specific_show(model, id)
    model.find(id)
  end

  #################################
  #                               #
  #       PROTECTED METHODS       #
  #                               #
  #################################

  protected

  ####   AUTHENTICATION   ####

  def auth
    if params[:authentication].blank?
      {}
    else
      params.require(:authentication).permit(:institution_id, :user_id, :api_key, :authentication_token)
    end
  end

  # provides the institution_id from the authentication block
  def auth_inst_id
    auth[:institution_id]
  end
  # provides the user_id from the authentication block
  def auth_user_id
    auth[:user_id]
  end

  # check existence of auth params
  def auth_params_exist
    auth.key?(:user_id) && auth.key?(:api_key)
  end

  ####   PUSH NOTIFICATIONS   ####

  def notify(the_user, the_peck)
    logger.info "sent peck to #{the_peck.user_id}"

    apple_notifications = {}
    google_notifications = {}
    google_collapse_notifications = {}

    the_user.unique_device_identifiers.each do |device|
      # date of creation of most recent user to use this device
      udid_id = UniqueDeviceIdentifier.where(udid: device.udid).sorted.last.id

      # ID of most recent user to use this device
      uid = UdidUser.where(unique_device_identifier: udid_id).sorted.last.user_id

      # token for this udid
      the_token = device.token

      # as long as the token is not nil and the user is the most recent user
      if the_user.id == uid && the_token
        if the_peck.send_push_notification
          # collapse circle comments
          if device.device_type == 'android' && the_peck.notification_type == 'circle_comment'
            google_collapse_notifications[the_token] = the_peck.message
          elsif device.device_type == 'android'
            google_notifications[the_token] = the_peck.message
          else
            apple_notifications[the_token] = the_peck.message
          end
        end
      end
    end
    Communication::PushNotificationWorker.perform_async(apple_notifications, google_notifications, google_collapse_notifications, the_user.id)
  end

  def allowed_model_instances(model, auth_params)
    # basic authentication check
    model.where(institution_id: auth_params[:institution_id])
  end

  # returns a hash of only the search parameters that apply to the specific model being queried
  def model_search_params(model, params)
    search_params = []
    params.keys.each do |key|
      next unless model.column_names.include?(key)
      search_params << key
    end
    search_params
  end

  def android_request?
    request.user_agent =~ /android/i
  end

  def apple_request?
    request.user_agent =~ /iphone|ipad|ipod/i
  end
end
