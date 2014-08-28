# Version 2 of the Production Deployment

A single load-balancing reverse-proxy running Nginx, with a number of application servers sitting behind it running Unicorn and the rails application. Each of these accesses the mysql database server that also runs a centralized copy of redis for the Sidekiq jobs. Uses the same remote database server as production deployment v1.

#### Base configuration walkthroughs
- scaling rails: https://www.digitalocean.com/community/tutorials/how-to-scale-ruby-on-rails-applications-across-multiple-droplets-part-1
- dedicated mySQL server: https://www.digitalocean.com/community/tutorials/scaling-ruby-on-rails-setting-up-a-dedicated-mysql-server-part-2
- New Relic Monitoring: https://rpm.newrelic.com/accounts/728064/servers/get_started#platform=rhel


## Server setups

#### Yggdrasil

As the great tree in norse mythology that connected the worlds unto each other, so too does our load-balancing reverse proxy connect our application servers to our users.

- running CentOS 7
- ports 80 and 443 (will) redirect to the main website at www.peckapp.com
- **API Port:** 7621
 - this is the port at which all of our apps will connect in order to access the API

### Application Servers

- `yum -y update`
- EPEL
  - **FOR CENTOS 6:** `rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm`
  - `yum -y update`
- Security
  - `yum install fail2ban` for security purposes
  - `chkconfig fail2ban on`
  - `cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local`
  - edit local jail configuration as necessary
- User creation
  - `useradd deployer`
  - `groupadd deployers`
  - `usermod -a -G deployers deployer`
  - `ssh-copy-id -i /path/to/key deployer@ipaddr` to setup ssh key login
- walk through scaling rails application server setup with CentOS and Unicorn
  - `yum -y update`
  - `yum groupinstall -y 'development tools'`
  - `yum install -y curl-devel nano sqlite-devel libyaml-devel`
  - `curl -L get.rvm.io | bash -s stable`
  - `source /etc/profile.d/rvm.sh`
  - `rvm reload`
  - `rvm install 2.1.2`
  - `yum install -y nodejs`
  - `gem install --no-ri --no-rdoc bundler rails`
  - `gem install --no-ri --no-rdoc unicorn`
- additional setup
  - `yum install -y mysql mysql-devel`
  - `yum install -y ImageMagick`
  - `yum install -y xorg-x11-server-Xvfb firefox`
- add server to Capistrano deploy file
- on local: `cap production deploy`

#### Eir

#### Ran

##### More to come! possible names...
- var: godess of contract
- mani: god of moon
- dagr: god of daytime
- vor: godess of wisdom
- sif: godess of harvest
- nott: goddess of night
- odin: god of war, ruler of gods
- tyr: god of war and the skies

### Database Servers

#### Magni
- **MySQL Port:** tbd
- **Redis Port:** 7347
- Install latest stable Redis version: https://gist.github.com/nghuuphuoc/7801123
