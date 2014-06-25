class RegistrationsControllerController < Devise::RegistrationsController
  format.json {
  if !params[:api_key].blank? and params[:api_key] == API_KEY
    build_resource
    if resource.save
      sign_in(resource)
      resource.reset_authentication_token!
      render :template => '/devise/registrations/signed_up' #rabl template with authentication token
    else
      render :template => '/devise/registrations/new' #rabl template with errors
    end
  else
    render :json => {'errors'=>{'api_key' => 'Invalid'}}.to_json, :status => 401
  end
}
format.any{super}

  def new
    super
  end

  def create
      resource = warden.authenticate!(:scope => resource_name, :recall => " {controller_path}#new")
    sign_in(resource_name, resource)
    current_user.reset_authentication_token!
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def update
    super
  end
end
