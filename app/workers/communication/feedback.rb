module Communication
  class Feedback
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id, content, category, institution_id)
      user = User.find(id)
      FeedbackMailer.send_feedback(user, id, content, category, institution_id).deliver
    end
  end
end
