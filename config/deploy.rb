# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, 'webservice'
set :repo_url, 'git@github.com:peckapp/webservice.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :use_sudo, false

# Default value for :scm is :git, specifies branch of the repository to access
set :scm, :git
set :branch, 'master'

# uses a more efficient technique for file deployment, fetching only changes from repo
set :deploy_via, :remote_cache

set :conditionally_migrate, true

set :migration_role, :db # 'migrator' # Defaults to 'db'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false, must remain false to use capistrano-sidekiq for some reason
set :pty, false

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/environment_variables.yml config/certs/ck.pem
                      config/initializers/sidekiq.rb)

# Default value for linked_dirs is []
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/images config/certs)

# custom database sync task settings
set :sync_directories, %w() # nothing to sync by default. Could use this to move config files remotely in production
set :sync_tables, %w(resource_types scrape_resources data_resources selectors) # custom addon to found recipe
set :sync_backups, 3

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# handles issues with rails c in deployed environments
set :bundle_binstubs, nil

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application by touching restart file'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute :touch, File.join(current_path, 'tmp', 'restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :updated, :migrate
end

namespace :load do
  task :defaults do
    set :conditionally_migrate, fetch(:conditionally_migrate, false)
    set :migration_role, fetch(:migration_role, :db)
  end

end

# send notification to new relic of deployment
after 'deploy:updated', 'newrelic:notice_deployment'
