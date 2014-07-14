# loads in environment variables for proper environment if a file exists locally

module EnvironmentVariables
  class Application < Rails::Application
    config.before_configuration do
      env_file = Rails.root.join("config", 'environment_variables.yml').to_s

      if File.exists?(env_file)
        yaml_for_env = YAML.load_file(env_file)[Rails.env]
        if ! yaml_for_env.blank? # protects against empty yaml entries
          yaml_for_env.each do |key, value|
            ENV[key.to_s] = value
          end # end YAML.load_file
        end # end ! yaml_for_env.blank?
      end # end if File.exists?
    end # end config.before_configuration
  end # end class
end # end module
