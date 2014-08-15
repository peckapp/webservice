class UserMailer < ActionMailer::Base
  default from: "noreply@peckapp.com"

  def registration_confirmation(user, id, fb_link)
    @user = user
    @id = id
    @fb_link = fb_link
    mail(to: "#{@user.first_name} <#{@user.email}>", subject: "Thanks for registering for Peck!")
  end
end
