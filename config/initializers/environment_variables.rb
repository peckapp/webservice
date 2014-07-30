# loads in environment variables for proper environment if a file exists locally

module EnvironmentVariables
  # extends rails application class
  class Application < Rails::Application
    config.before_configuration do
      env_file = Rails.root.join('config', 'environment_variables.yml').to_s
      if File.exist?(env_file)
        yaml_for_env = YAML.load_file(env_file)[Rails.env]
        unless yaml_for_env.blank? # protects against empty yaml entries
          yaml_for_env.each do |key, value|
            ENV[key.to_s] = value
          end # end YAML.load_file
        end # end ! yaml_for_env.blank?
      end # end if File.exists?
    end # end config.before_configuration

    # properly assign environment variables loaded here
    config.after_initialize do
      # Apple Push Notification Service certificate key
      APNS.pass = ENV['PUSH_CERT_PASS']
      # Google Cloud Messenger API key
      GCM.key = ENV['GCM_API_KEY']
    end # end config.after_initialize
  end # end class
end # end module
