module Communication
  class SendEmail
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id)
      user = User.find(id)
      UserMailer.registration_confirmation(user, id).deliver      
    end
  end
end
