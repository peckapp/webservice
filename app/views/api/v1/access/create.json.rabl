object :@user

attributes :id, :first_name, :last_name, :email, :blurb, :authentication_token, :api_key

node(:response) {@user.blank? ? "User did not successfully log in" : "#{@user.email} has successfully logged in"}
