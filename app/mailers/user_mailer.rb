class UserMailer < ActionMailer::Base
  default from: "anthoney@peckapp.com"

  def registration_confirmation(user, id)
    @user = user
    @id = id
    mail(to: "#{@user.first_name} <#{@user.email}>", subject: "Thanks for registering for Peck!")
  end
end
