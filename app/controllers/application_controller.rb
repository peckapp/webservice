class ApplicationController < ActionController::Base

  # allows all classes to inherit
  before_action :confirm_minimal_access

  def confirm_logged_in
    if set_authentication_token && auth[:authentication_token] == User.find(session[:user_id]).authentication_token
      return true
    else
      render :file => "public/401.html", :status => :unauthorized
      return false
    end
  end

  # def confirm_authentication_token
  #   if confirm_logged_in
  #     user = User.find(session[:user_id])
  #     unless auth[:authentication_token] == user.authentication_token
  #       render :file => "public/401.html", :status => :unauthorized
  #       return false
  #     end
  #   end
  #   return true
  # end

  def confirm_minimal_access

    if auth_params_exist
      # check validity of existing session
      if session[:user_id] == auth[:user_id] && session[:api_key] == auth[:api_key]
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
      return false
    else
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def specific_index(model, params_hash)

    search_params = model_search_params(model,params_hash)

    # uses authentication institution_id to get initial set
    # result = allowed_model_instances(model, params[:authentication])
    result = model.all

    # if there is at least one parameter, filter result
    if ! search_params.blank?
      for p in search_params do
        if params[p]
          result = result.where(p => params[p])
        end
      end
    end

    return result
  end

  # show instance of model
  def specific_show(model, id)
    model.find(id)
  end

  private

    def auth
      if params[:authentication].blank?
        {}
      else
        params[:authentication]
      end
    end

    def set_authentication_token
      # if session has authentication_token (set when logged in)
      if User.find(session[:user_id]).authentication_token

        # as longs as the authentication token parameter is not nil, keep that as the auth token.
        if auth[:authentication_token]
          return auth[:authentication_token]

          # otherwise, assign the authentication token to be the same as the session one
        else
          auth[:authentication_token] = User.find(session[:user_id]).authentication_token
        end

        # if there is no session with the authentication token, authentication token should be nil.
      else
        auth[:authentication_token] = nil
      end
      return auth[:authentication_token]
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
      for key in params.keys do
        next unless model.column_names.include?(key)
        search_params << key
      end
      search_params
    end
end
