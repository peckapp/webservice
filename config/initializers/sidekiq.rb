# sets up redis and sidekiq in the Hekoku environment based on environment variables

if ENV['REDISTOGO_URL']
  REDIS = Redis.new(url: ENV['REDISTOGO_URL'])

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDISTOGO_URL'], namespace: 'sidekiq' }
  end
end
