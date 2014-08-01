object :@user

attributes :id, :first_name, :last_name, :email, :blurb, :authentication_token, :api_key, :image, :institution_id, :created_at, :updated_at

node(:response) {@user.blank? ? "User did not successfully log in" : "#{@user.email} has successfully logged in"}

node(:device_identifier) {@udid.blank? ? nil : @udid}
