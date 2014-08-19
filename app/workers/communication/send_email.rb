module Communication
  class SendEmail
    include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(id, fb_link)
      user = User.find(id)
      logger.info "sending email to user: #{user.id} named #{user.first_name} #{user.last_name} with link: #{fb_link}"
      UserMailer.registration_confirmation(user, id, fb_link).deliver
    end
  end
end
