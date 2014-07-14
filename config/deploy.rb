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

set :conditionally_migrate, true

set :migration_role, %w(db) # 'migrator' # Defaults to 'db'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/environment_variables.yml}

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

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate => [:set_rails_env] do
    puts "on primary  (#{on primary } fetch(:migration_role) ==> #{on primary fetch(:migration_role)}"
    on primary fetch(:migration_role) do
      puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      conditionally_migrate = fetch(:conditionally_migrate)
      info '[deploy:migrate] Checking changes in /db/migrate' if conditionally_migrate
      if conditionally_migrate && test("diff -q #{release_path}/db/migrate #{current_path}/db/migrate")
        info '[deploy:migrate] Skip `deploy:migrate` (nothing changed in db/migrate)'
      else
        info '[deploy:migrate] Run `rake db:migrate`' if conditionally_migrate
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:migrate"
          end
        end
      end
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
