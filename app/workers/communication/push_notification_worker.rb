# this class will handle sending out push notifications to users
# needs to be asynchronous so as not to slow down server responses to request
module Communication
  class PushNotificationWorker
    include Sidekiq::Worker
    sidekiq_options unique: true

    ### this is not an idempotent job as sidekiq specifies that it should be.
    # could separate these jobs into a single notification send, but that eliminates the possibility
    # of using a persistent connection that increases reliability. tradeoffs there

    # notification hash is of device_token string keys related to message hash values in the Pushmeup format
    # currently only supports ios notifications
    def perform(apple_hash, google_hash, google_hash_collapsable, the_key)
      logger.info "sending notifications with apple_hash: #{apple_hash}, and google_hash: #{google_hash}"

      # Define that we want persistent connection
      unless apple_hash.blank?
        APNS.start_persistence

        apple_notifications = []

          apple_hash.each do |device_token, message|
            logger.info "push notification sent to apple device: #{device_token}"
            apple_notifications << APNS::Notification.new(device_token, alert: message,  badge: 1, sound: 'default')
          end

        APNS.send_notifications(apple_notifications)

        APNS.stop_persistence
      end

      ### Android ###
      google_notifications = []

      unless google_hash.blank?
        google_hash.each do |device_token, the_message|
          logger.info "push notification sent to google device: #{device_token}"
          google_notifications << GCM::Notification.new(device_token, data: {message: the_message})
        end
      end

      unless google_hash_collapsable.blank?
        google_hash_collapsable.each do |device_token, the_message|
          logger.info "collapsable push notification sent to google device: #{device_token}"
          google_notifications << GCM::Notification.new(device_token, data: {message: the_message}, collapse_key: the_key, delay_while_idle: false)
        end
      end

      GCM.send_notifications(google_notifications) unless google_notifications.blank?
    end
  end
end
