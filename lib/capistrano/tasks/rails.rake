# found at: https://gist.github.com/toobulkeh/8214198

namespace :rails do
  desc 'Open the rails console on each of the remote servers'
  task :console do
    on roles(:app) do |server|
      server_index = ARGV[2].to_i

      return if server != roles(:app)[server_index]

      puts "Opening a console on: #{host}...."

      cmd = "ssh #{server.user}@#{host} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails console'"

      puts cmd

      exec cmd
    end

    # on roles(:app), primary: true do |host| # does it for each host, bad.
    #   rails_env = fetch(:stage)
    #   execute_interactively "ruby #{current_path}/bin/rails console #{rails_env}"
    # end
  end

  desc 'Open the rails dbconsole on each of the remote servers'
  task :dbconsole do
    on roles(:db) do |host| # does it for each host, bad.
      rails_env = fetch(:stage)
      execute_interactively "ruby #{current_path}/bin/rails dbconsole #{rails_env}"
    end
  end

  def execute_interactively(command)
    user = fetch(:user)
    port = fetch(:port) || 22
    exec "ssh -l #{user} #{host} -p #{port} -t 'cd #{deploy_to}/current && #{command}'"
  end
end
