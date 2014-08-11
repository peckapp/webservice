class UserMailer < ActionMailer::Base
  default from: "anthoney@peckapp.com"

  def registration_confirmation(user)
    @user = user
    mail(to: "#{@user.first_name} <#{@user.email}>", subject: "Thanks for registering for Peck!")
  end

end
