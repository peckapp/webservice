# Version 1 Production Deployment

A single application server running Nginx, Passenger, and Rails connected to a remote database.

## Production Server

The production server is deployed to using similar syntax to the development server, but has two separate environments that can be setup

- Staging
 - The staging environment allows code to be pushed and tested in an environment similar to testing, but without affecting the current production deployment of the code that users are interacting with. It is a final stage of checks before deploying to production.
- Production
 - The production environment is where the live application code exists that the mobile applications will be interacting with.

 #### Server Configurations
- step through setup at: https://www.digitalocean.com/community/tutorials/how-to-deploy-rails-apps-using-passenger-with-nginx-on-centos-6-5
- install fail2ban: https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-centos-6
- for local development install mysql
 - `yum install mysql-server mysql-devel`
 - `chkconfig mysqld on`
 - `mysql_secure_installation`
 - configure mysql users and database permissions: https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
- install redis for sidekiq
 - `yum install redis`
 - `chkconfig redis on`
- install ImageMagick for paperclip gem image manipulation
 - `yum install ImageMagick`
- verify startup configuration
 - `chkconfig --list`
- configure users appropriately
 - `addgroup deployers`
 - `useradd deployer`
 - `usermod -a -G deployers deployer`
 - use `visudo` to edit the sudoers file if necessary

## Monitoring Points
- Our custom API: buri.peckapp.com:3500/api/
 - nothing here as of yet... could display some public status information
- PHPMyAdmin: magni.peckapp.com/sqladmin
 - authenticate with appropriate mySQL database information
- Sidekiq task monitoring: buri.peckapp.com:3500/tasks
 - will be setting up nginx http authentication for access to this site
- Kibana Log Monitoring: buri.peckapp.com:9222
 - currently only on new buri server without DNS connection
 - will be setting up nginx http authentication for access to this site
- `fail2ban` is used in tandem with [badIPs.com](www.badips.com) to keep track of malicious hosts. our specific information can be seen using our key.

### Status Commands
- Nginx
 - `service nginx status`
- Passenger
 - `passenger-status`

### Config Files
- Nginx
 - `/opt/nginx/conf/nginx.conf`
 - `/opt/nginx/conf/available-sites/*`
- Kibana
 - `/usr/share/nginx/kibana3/config.js`
- Elasticsearch
 - `/etc/elasticsearch/elasticsearch.yml`
- Logstash server
 - input: `/etc/logstash/conf.d/01-lumberjack-input.conf`
 - filter: `/etc/logstash/conf.d/*.conf`
 - patterns `/opt/nginx/logstash/patterns/*`
 - output: `/etc/logstash/conf.d/30-lumberjack-output.conf`
- Logstash forwarders
 - `/etc/logstash-forwarder`
 - `/etc/sysconfig/logstash-forwarder`

#### Tuning Parameters
- Nginx main configuration `/opt/nginx/conf/nginx.conf`
 - `passenger_max_pool_size` can be modified to indicate the number fo processes that passenger runs. read more about passenger concurrency here: http://blog.phusion.nl/2013/03/12/tuning-phusion-passengers-concurrency-settings/
 - `server_names_hash_bucket_size` was manually increased to allow for more server names to be specified
 - buffers were added as possibly fixes for out of memory errors, not sure if these perform any important role for us

### Service restarts
- Nginx
 - `service nginx restart`
- Kibana/ElasticSearch/Logstash
 - `service elasticsearch restart`
 - `service logstash restart`
 - `service logstash-forwarder restart`
- Passenger
 - `touch /home/deployer/apps/webservice_development/current/tmp/restart.txt`
