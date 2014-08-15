module Communication
  class PasswordReset
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id)
      user = User.find(id)
      PasswordResetMailer.delay.reset_pass(user, id).deliver
    end
  end
end
