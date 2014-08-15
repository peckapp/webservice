module Communication
  class SendEmail
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id, fb_link)
      user = User.find(id)
      UserMailer.delay.registration_confirmation(user, id, fb_link).deliver
    end
  end
end
