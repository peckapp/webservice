class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # def helpers
  #   Helper.instance
  # end
  #
  # class Helper
  #   include ActionView::Helpers::TextHelper
  #   include ActionView::Helpers::SanitizeHelper
  # end
  #
  # def sanitize_stuff(params_hash)
  #   params_hash.each do |param|
  #     helpers.sanitize(param)
  #   end
  # end
  def confirm_logged_in
    unless session[:user_id]
      render :file => "public/401.html", :status => :unauthorized
      return false
    else
      return true
    end
  end

  # def confirm_correct_school(strong_params)
  #   user = User.find(session[:user_id])
  #   strong_params[:institution_id] = user.institution_id
  # end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(api_key: token)
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
