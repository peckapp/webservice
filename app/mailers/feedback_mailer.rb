class FeedbackMailer < ActionMailer::Base
  def send_feedback(user, id, content, category, institution_id)
    @user = user
    @id = id
    @content = content
    @institution = Institution.find(institution_id).name
    if @user.email
      mail(to: "support@peckapp.com", from: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Feedback: #{category} - #{@institution}")
    else
      mail(to: "support@peckapp.com", from: "Anonymous User <noreply@peckapp.com>", subject: "Feedback: #{category} - #{@institution}")
    end
  end
end
