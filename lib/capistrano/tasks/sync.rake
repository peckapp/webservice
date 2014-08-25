require 'yaml'
require 'pathname'

#
# Capistrano sync.rb task for syncing databases and directories between the
# local development environment and different multi_stage environments. You
# cannot sync directly between two multi_stage environments, always use your
# local machine as loop way.
#
# Author: Michael Kessler aka netzpirat
# Gist:   111597
#
# Released under the MIT license.
# Kindly sponsored by Screen Concept, www.screenconcept.ch
#
# found at: https://gist.github.com/netzpirat/111597
#
namespace :sync do

  # after 'deploy:setup', 'sync:setup'

  desc <<-DESC
    Creates the sync dir in shared path. The sync directory is used to keep
    backups of database dumps and archives from synced directories. This task will
    be called on 'deploy:setup'
  DESC
  task :setup do
    on primary :db do
      execute "cd #{shared_path}; mkdir -p sync"
    end
    run_locally do
      execute 'mkdir -p sync'
    end
  end

  namespace :down do

    # desc <<-DESC
    #   Syncs the database and declared directories from the selected multi_stage environment
    #   to the local development environment. This task simply calls both the 'sync:down:db' and
    #   'sync:down:fs' tasks.
    # DESC
    # task :default do
    #   db && fs
    # end

    desc <<-DESC
      Syncs database from the selected multi_stage environement to the local develoment environment.
      The database credentials will be read from your local config/database.yml file and a copy of the
      dump will be kept within the shared sync directory. The number of backups that will be kept is
      declared in the sync_backups variable and defaults to 5.
    DESC
    task :db do
      on primary :db do # only: { primary: true } do
        stage = fetch(:stage, 'development')
        filename = "database.#{stage}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"
        # on_rollback { delete "#{shared_path}/sync/#{filename}" } # not supported in capistrano 3

        # Remote DB dump
        username, password, database, host = remote_database_config(stage)
        remote_file_path = "#{shared_path}/sync/#{filename}"
        execute "touch #{remote_file_path}; mysqldump -u #{username} --password='#{password}' -h #{host || 'localhost'} #{database} #{sync_tables} | bzip2 -9 > #{remote_file_path}"

        purge_old_backups 'database'

        # Download dump
        local_file_path = "sync/#{filename}"
        download! remote_file_path, local_file_path

        # Local DB import
        run_locally do
          username, password, database = local_database_config('development')
          execute "bzip2 -d -c #{local_file_path} | mysql -u #{username} --password='#{password}' #{database}; rm -f #{local_file_path}"
        end

        info "sync database from the stage '#{stage}' to local finished"
      end
    end

    # desc <<-DESC
    #   Sync declared directories from the selected multi_stage environment to the local development
    #   environment. The synced directories must be declared as an array of Strings with the sync_directories
    #   variable. The path is relative to the rails root.
    # DESC
    # task :fs, roles: :web, once: true do
    #
    #   server, port = host_and_port
    #
    #   Array(fetch(:sync_directories, [])).each do |syncdir|
    #     unless File.directory? "#{syncdir}"
    #       logger.info "create local '#{syncdir}' folder"
    #       Dir.mkdir "#{syncdir}"
    #     end
    #     logger.info "sync #{syncdir} from #{server}:#{port} to local"
    #     destination, base = Pathname.new(syncdir).split
    #     system "rsync --verbose --archive --compress --copy-links --delete --stats --rsh='ssh -p #{port}' #{user}@#{server}:#{current_path}/#{syncdir} #{destination}"
    #   end
    #
    #   logger.important "sync filesystem from the stage '#{stage}' to local finished"
    # end

  end

  namespace :up do

    # desc <<-DESC
    #   Syncs the database and declared directories from the local development environment
    #   to the selected multi_stage environment. This task simply calls both the 'sync:up:db' and
    #   'sync:up:fs' tasks.
    # DESC
    # task :default do
    #   db && fs
    # end

    desc <<-DESC
      Syncs database from the local develoment environment to the selected mutli_stage environement.
      The database credentials will be read from your local config/database.yml file and a copy of the
      dump will be kept within the shared sync directory. The amount of backups that will be kept is
      declared in the sync_backups variable and defaults to 5.
    DESC
    task :db do
      on primary :db do

        filename = "database.#{stage}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"

        # on_rollback do
        #   delete "#{shared_path}/sync/#{filename}"
        #   system "rm -f #{filename}"
        # end

        # Make a remote backup of ENTIRE remote database before importing
        username, password, database, host = remote_database_config(stage)
        remote_file_path = "#{shared_path}/sync/#{filename}"
        execute "mysqldump -u #{username} --password='#{password}' #{database} -h #{host || 'localhost'} | bzip2 -9 > #{remote_file_path}"

        run_locally do
          # Local DB export
          filename = "dump.local.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"
          username, password, database = local_database_config('development')
          puts 'running dump locally'
          execute "mysqldump -u #{username} --password='#{password}' #{database} #{sync_tables} | bzip2 -9 > #{filename}"
        end

        file = File.open(filename)
        upload! file, remote_file_path

        run_locally do
          execute "rm -f #{filename}"
        end

        # Remote DB import
        username, password, database, host = remote_database_config(stage)
        execute "bzip2 -d -c #{remote_file_path} | mysql -u #{username} --password='#{password}' -h #{host || 'localhost'} #{database}; rm -f #{remote_file_path}"
        purge_old_backups 'database'

        info "sync database from local to the stage '#{stage}' finished"
      end
    end

    desc <<-DESC
      Sync declared directories from the local development environement to the selected multi_stage
      environment. The synced directories must be declared as an array of Strings with the sync_directories
      variable.  The path is relative to the rails root.
    DESC
    task :fs do
      on roles(:web), once: true do
        unless stage == :production
          error "fs sync currently only configured for production, unable to handle: #{stage}"
          next
        end

        server, port = host_and_port
        Array(fetch(:sync_directories, [])).each do |syncdir|
          destination, base = Pathname.new(syncdir).split
          if File.directory? "#{syncdir}"
            # Make a backup
            info "backup #{syncdir}"
            execute "tar cjf #{shared_path}/sync/#{base}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.tar.bz2 #{current_path}/#{syncdir}"
            purge_old_backups "#{base}"
          else
            info "Create '#{syncdir}' directory"
            execute "mkdir #{current_path}/#{syncdir}"
          end

          run_locally do
            # Sync directory up
            logger.info "sync #{syncdir} to #{server}:#{port} from local"
            execute "rsync --verbose --archive --compress --keep-dirlinks --delete --stats --rsh='ssh -p #{port}' #{syncdir} #{user}@#{server}:#{current_path}/#{destination}"
          end
        end
        logger.important "sync filesystem from local to the stage '#{stage}' finished"
      end
    end

  end

  #
  # Reads the database credentials from the local config/database.yml file
  # +db+ the name of the environment to get the credentials for
  # Returns username, password, database
  #
  def remote_database_config(db)
    info "db: #{db}"
    env_file = "#{shared_path}/config/database.yml"

    database_data = download! env_file
    database = YAML.load(database_data)[db.to_s]
    return if database.nil? # protects against empty yaml entries

    [database['username'], database['password'], database['database'], database['host']]
  end

  def local_database_config(db)
    env_file = 'config/database.yml'
    return unless File.exist?(env_file)

    database = YAML.load_file(env_file)[db]
    return if database.nil? # protects against empty yaml entries

    [database['username'], database['password'], database['database']]
  end

  def stage
    fetch(:stage)
  end

  #
  # Returns the actual host name to sync and port
  #
  def host_and_port
    [roles[:web].servers.first.host, ssh_options[:port] || roles[:web].servers.first.port || 22]
  end

  #
  # Creates a space-separated string of all the table names meant to be synced by the script
  # table names defined in config/deploy.rb
  #
  def sync_tables
    Array(fetch(:sync_tables)).reduce('') { |a, e| a << ' ' << e }
  end

  #
  # Purge old backups within the shared sync directory
  #
  def purge_old_backups(base)
    count = fetch(:sync_backups, 5).to_i
    backup_files = capture("ls -xt #{shared_path}/sync/#{base}*").split.reverse
    if count >= backup_files.length
      warn 'no old backups to clean up'
    else
      info "keeping #{count} of #{backup_files.length} sync backups"
      delete_backups = (backup_files - backup_files.last(count)).join(' ')
      execute "rm -rf #{delete_backups}"
    end
  end

end
