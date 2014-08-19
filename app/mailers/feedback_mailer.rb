class FeedbackMailer < ActionMailer::Base
  def send_feedback(user, id, content, category)
    @user = user
    @id = id
    @content = content
    mail(to: "support@peckapp.com", from: "#{@user.first_name} <#{@user.email}>", subject: "Feedback: #{category}")
  end
end
