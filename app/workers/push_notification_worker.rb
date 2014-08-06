# this class will handle sending out push notifications to users
# needs to be asynchronous so as not to slow down server responses to request
class PushNotificationWorker
  include Sidekiq::Worker

  ### this is not an idempotent job as sidekiq specifies that it should be.
  # could separate these jobs into a single notification send, but that eliminates the possibility
  # of using a persistent connection that increases reliability. tradeoffs there

  # notification hash is of device_token string keys related to message hash values in the Pushmeup format
  # currently only supports ios notifications
  def perform(notification_hash)
    # Define that we want persistent connection
    APNS.start_persistence

    notifications = []

    notification_hash.each do |device_token, message|
      notifications << APNS::Notification.new(device_token, message)
    end

    APNS.send_notifications(notifications)

    APNS.stop_persistence
  end
end
