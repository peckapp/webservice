# contains code that applies to all the classes which subclass it, including all the API controllers
# enforces security mechanisms for everything unless specified otherwise
class ApplicationController < ActionController::Base
  # allows all classes to inherit
  before_action :confirm_minimal_access

  def confirm_logged_in
    # user is found by session id
    user = User.find(session[:user_id])

    # the auth token must be present
    if auth[:authentication_token] && auth[:authentication_token] == user.authentication_token
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

  protected

    def auth
      if params[:authentication].blank?
        {}
      else
        params[:authentication]
      end
    end

    # check existence of auth params
    def auth_params_exist
      if auth[:user_id].blank? || auth[:api_key].blank?
        return false
      else
        return true
      end
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
end
