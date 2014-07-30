# loads in environment variables for proper environment if a file exists locally

module EnvironmentVariables
  # extends rails application class
  class Application < Rails::Application
    # properly assign environment variables loaded here
    config.after_initialize do
      # Apple Push Notification Service certificate key
      APNS.pass = ENV['PUSH_CERT_PASS']
      # Google Cloud Messenger API key
      GCM.key = ENV['GCM_API_KEY']
    end # end config.after_initialize
  end # end class
end # end module
