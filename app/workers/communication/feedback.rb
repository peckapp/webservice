module Communication
  class Feedback
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id, content, category)
      user = User.find(id)
      FeedbackMailer.send_feedback(user, id, content, category).deliver
    end
  end
end
