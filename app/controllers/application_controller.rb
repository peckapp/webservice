class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def institution_index(model)
    if params[:institution_id]
      models = model.where(institution_id: params[:institution_id], active: true)
    else
      models = model.where(active:true)
    end
    return models
  end

  def institution_show(model)
    if params[:institution_id]
      theModel = model.where(institution_id: params[:institution_id], active: true).find(params[:id])
    else
      theModel = model.find(params[:id])
    end
    return theModel
  end
end
