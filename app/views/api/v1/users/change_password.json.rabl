object :@user

attributes :id, :first_name, :last_name, :email, :password

node(:response) {@user.blank? ? "Old password and/or password confirmation was wrong" : "password was successfully changed!"}
