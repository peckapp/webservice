module Communication
  class SendEmail
    include Sidekiq::Worker

    def perform(id)
      user = User.find(id)
      UserMailer.registration_confirmation(user, id).deliver
    end
  end
end
