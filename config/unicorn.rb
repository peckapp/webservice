

# Set the working application directory
# working_directory "/path/to/your/app"
working_directory '/home/deployer/apps/webservice_production/current'

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid '/home/deployer/apps/webservice_production/shared/tmp/pids/unicorn.pid'

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path '/home/deployer/apps/webservice_production/shared/log/unicorn.log'
stdout_path '/home/deployer/apps/webservice_production/shared/log/unicorn.log'

# Number of processes
# Rule of thumb: 2x per CPU core available
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
