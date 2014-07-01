class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def index(model, *parameter)
    if params[parameter]
      models = model.where(parameter => params[parameter])
    else
      models = model.all
    end
    return models
  end

  def show(model, *parameter)
    if params[parameter]
      theModel = model.where(parameter => params[parameter).find(params[:id])
    else
      theModel = model.find(params[:id])
    end
    return theModel
  end
end
