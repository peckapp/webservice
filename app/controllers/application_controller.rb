class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def specific_index(model, *parameters)

    result = model.all

    # [[parameters]] => [parameters]
    flat_parameters = parameters.flatten!

    # if there is at least one parameter, filter result
    if ! flat_parameters.blank?
      for p in flat_parameters do
        if params[p]
          result = result.where(p => params[p])
        end
      end
    end

    return result
  end

  def specific_show(model, parameter)
    if params[parameter]
      theModel = model.where(parameter => params[parameter]).find(params[:id])
    else
      theModel = model.find(params[:id])
    end
    return theModel
  end
end
