# sets the rails_env value for this stage. normally inferred, but capistrano3-unicorn requires it to be explicit
set :rails_env, 'staging'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/apps/webservice_staging'

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# Define server(s)
server 'buri.peckapp.com', user: 'deployer', roles: %w{web app db}
# server 'magni.peckapp.com', user: 'deployer', roles: %w{db}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
  keys: %w(File.join(ENV["HOME"], ".ssh", "peck_secure")),
  forward_agent: false,
  user: 'deployer',
  auth_methods: %w(publickey password)
}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
