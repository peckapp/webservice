class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # Merge conflict, wanted to be sure correct one was chosen
  #def institution_index(model)
  #  if params[:institution_id]
  #    models = model.where(institution_id: params[:institution_id], active: true)

  def specfic_index(model, parameter)
    if params[parameter]
      models = model.where(parameter => params[parameter], active: true)
    else
      models = model.where(active: true)
    end
    return models
  end

  def specific_show(model, parameter)
    if params[parameter]
      theModel = model.where(parameter => params[parameter], active: true).find(params[:id])
    else
      theModel = model.where(active: true).find(params[:id])
    end
    return theModel
  end

  # Merge conflict, wanted to be sure correct one was chosen
  #def institution_show(model)
  #  if params[:institution_id]
  #    theModel = model.where(institution_id: params[:institution_id], active: true).find(params[:id])
