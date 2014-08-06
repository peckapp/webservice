require File.expand_path('../boot', __FILE__)

require 'rails/all'

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

    # loads code in lib directory
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

    # default doesn't need SSL, change this manualy in specific environments
    config.force_ssl = false

    # loads environment variables from rails-specfiic yml file
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
  end
end
