# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, 'webservice'
set :repo_url, 'git@github.com:peckapp/webservice.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :use_sudo, false

# Default value for :scm is :git, specifies branch of the repository to access
set :scm, :git
set :branch, "master"

# uses a more efficient technique for file deployment, fetching only changes from repo
set :deploy_via, :remote_cache

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute :touch, File.join(current_path, 'tmp', 'restart.txt')
    end
  end

  desc "Symlink shared config files"
  task :symlink_config_files do
    on roles(:app) do# , in: :sequence, wait: 5 do
      # links the local database config file
      execute :ln, "-nfs #{ deploy_to }/shared/config/database.yml #{ release_path }/config/database.yml"
      # links the local environment variable load file
      execute :ln, "-nfs #{ deploy_to }/shared/config/environment_variables.yml #{ release_path }/config/environment_variables.yml"
    end
  end

  # must be executed here so that files are in place but nothing has required the file yet. see /lib/capistrano/tasks/framework.rake for other tasks
  after :updating, :symlink_config_files

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

# namespace :bundle do
#
#   desc "run bundle install and ensure all gem requirements are met"
#   task :install do
#     on roles(:app), in: :sequence, wait: 5 do
#       execute "cd #{current_path} && bundle install  --without=test --no-update-sources"
#     end
#   end
#
# end
# before "deploy:restart", "bundle:install"
