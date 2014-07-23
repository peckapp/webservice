object :@user

attributes :id, :first_name, :last_name, :email, :password

node(:response) {@user.old_pass_match ? "Password was successfully changed!" : "Old password was wrong"}
