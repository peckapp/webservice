require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'silencer/logger'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# enable garbage collection profiling for use with New Relic
GC::Profiler.enable

module Webservice
  # loads the full rails application
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # loads all code in lib directory, may want to itemize this at some point if lib directory gets bloated
    config.autoload_paths  << Rails.root.join('lib') # += %W(#{config.root}/lib)

    # sets up a cache store, accessed with 'Rails.cache'
    # first argument is the cache store to use, rest will be passed as arguments to the cache store constructor
    # Create a concrete subclass of ActiveSupport::Cache::Store, or use one provided
    # further detail at: http://guides.rubyonrails.org/caching_with_rails.html
    config.cache_store = :memory_store, { size: 64.megabytes } # default for environments
    # config.cache_store = :file_store, "/path/to/cache/directory"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # default doesn't need SSL, change this manually in specific environments
    config.force_ssl = false

    # swaps out the standard middleware logger for a silenceable one that is a simple subclass
    config.middleware.swap Rails::Rack::Logger, Silencer::Logger, silence: ['/api']

    # filters sensitive parameters out of the logs
    config.filter_parameters << :authentication_token << :api_key << :token

    # loads environment variables from rails-specific yml file
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

    # paperclip should use amazon S3 in all environments
    config.paperclip_defaults = {
      storage: :s3
    }

    # sendgrid action mailer settings
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: 587,
      domain: 'peckapp.com',
      user_name: 'atsou',
      password: 'cq2vkmzvC82uJDd3vcMj',
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end
