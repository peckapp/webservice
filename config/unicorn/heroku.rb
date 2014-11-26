# basic Unicorn configuration: https://devcenter.heroku.com/articles/rails-unicorn

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 15
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # start sidekiq on this same dyno to avoid needing a second one
  @sidekiq_pid ||= spawn('bundle exec sidekiq -c 1')

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
