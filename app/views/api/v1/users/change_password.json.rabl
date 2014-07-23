object :@user

attributes :id, :first_name, :last_name, :email, :password

node(:response) {@old_pass_match ? "password was successfully changed!" : "Old password was wrong"}
