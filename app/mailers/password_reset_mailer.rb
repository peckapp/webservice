class PasswordResetMailer < ActionMailer::Base
  default from: "anthoney@peckapp.com"

  def reset_pass(user, id)
    @user = user
    @id = id
    @temp_password = SecureRandom.hex(25)
    mail(to: "#{@user.first_name} <#{@user.email}>", subject: "Password Reset for Peck")
  end
end
