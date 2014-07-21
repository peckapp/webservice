node(:response) {@user.blank? ? "User did not successfully log in" : "#{@user.email} has successfully logged in"}
