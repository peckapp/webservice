class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def specific_index(model, params_hash)

    search_params = model_search_params(model,params_hash)

    for key in params_hash.keys do
      next unless model.column_names.include?(key)
      search_params << key
    end

    # use authentication institution_id to get initial set
    
    result = model.all

    # if there is at least one parameter, filter result
    if ! search_params.blank?
      for p in params_hash do
        if params[p]
          result = result.where(p => params[p])
        end
      end
    end

    return result
  end

  def specific_show(model, params_hash)

    search_params = model_search_params(model,params_hash)

    result = model.all

    # if there is at least one parameter, filter result
    if ! params_hash.blank?
      for p in params_hash
        if params[p]
          result = result.where(p => params[p])
        end
      end
    end

    return result.find(params[:id])
  end

  private

    # returns a hash of only the search parameters that apply to the specific model being queried
    def model_search_params(model, params)
      search_params = []

      for key in params_hash.keys do
        next unless model.column_names.include?(key)
        search_params << key
      end
    end

end
