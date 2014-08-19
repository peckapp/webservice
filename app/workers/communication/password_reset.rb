module Communication
  class PasswordReset
    include Sidekiq::Worker
    sidekiq_options unique: true

    def perform(id)
      user = User.find(id)
      PasswordResetMailer.reset_pass(user, id).deliver
    end
  end
end
