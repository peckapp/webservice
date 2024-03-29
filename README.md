# Peck Backend Ruby on Rails platform

## Purposes

This rails application serves as the API with which the mobile applications interact to store and retrieve data, the management system for the database, and the platform which automates scraping for our target institutions.

- API
 - Allows for structured and protected interactions between the app and the content stored within the database
- Database
 - Created through migrations and manipulated through models standard for the Rails platform
- Scraping
 - automated, customized tasks that retrieve data from member institutions at regular and dynamic time intervals to ensure that the most up-to-date information is being presented to users
 - accuracy and reliability of this system is absolutely key to our service

## API Communication Protocols

The API is the interface through which the mobile application will access user-specific information within the database, and handle all manner of operations changing user's settings, receiving user usage data, and adding user-generated content.

There will be a few primary tasks that the API will handle:

1. **Mass Updates** delivering all data relevant to a user when the mobile application launches on the device
- **Incremental Updates** delivering information which has changed since the user's last request to the server
- **User Creation** queries that occur on app startup when the app is configured for a school, and the subsequent updates to that user's information when a full identified account is created.
- **User-Created Content** requests from the user to create an event, message, or circle that will need to be put in the database and sent to other users as necessary
- **Push Notifications** messages sent to either google or apple in response to a change in system state that necessitates notifying users. Includes messages, event updates, circle additions, and more.

## Production Environment

While this application will be built in development environments on the Mac OSX laptops of the developers, the production environment will be CentOS 6.5 running the Nginx web server, with a secondary server running the mySQL database.

There are many additional options for the structure of the backend system, several of which are described in the Digital Ocean documentation linked to in the wiki pages.

### Production Deployment
Deployment of the rails application will be automated using [Capistrano](http://capistranorb.com) to update the server with the latest code. There will be three environments setup withing the Capistrano files that can be used to deploy the application.

#### Deploying Code
- setting up ssh keys on the server
 - have Aaron place your key in the `authorized_keys` file of the deployment user.
- to deploy code:
 - ensure necessary keys are in the ssh agent with `ssh-add /path/to/key`
 - `cap development deploy`
- other options from [capistrano-rails](https://github.com/capistrano/rails)
 - running migrations `cap development deploy:migrate`
 - pre-complie assets `cap development deploy:compile_assets`
 - see README for more options

### System setup

#### Ruby
We will be using Ruby 2.1.2 and the Gems specified in the repo's Gemfile, with the major extensions to the standard rails dependencies and various utilities falling into the category of scraping libraries.

#### Database Setup
We will be using the mySQL database for this application. The database configuration information that needs to be matched on your development machine can be found in the database.yml configuration file.

#### Automated Services
The scraping jobs will be running at automated intervals in the production environment, as well as other database analysis tasks to manage subscriptions and suggestions of events to the users. These tasks will be run using the `sidekiq` gem automated repeatedly using the companion `sidetiq` gem.

### Initial production system

We will begin with a front-end application server running Nginx with passenger and running the rails application. Sitting behind this server on the private network of our hosting provider [Digital Ocean](https://www.digitalocean.com), will be a database server holding all of the data for our scraped events, users, and the associated media. This server will be configured in the rails application for the production setting.

Other future options include replication of the database in a master-slave relationship to ensure relability, creating a front-end cache using Nginx to handle identical requests quickly while passing others along to the core rails application, and having a front-end load balancer that would pass requests to a variety of intermediate servers. A distributed deployment in this way would likely be done using Nginx as a front-end load balancer with a cluster of droplets running the [Unicorn](http://unicorn.bogomips.org) or [Puma](https://github.com/puma/puma) as the ruby Rack interface for each instance of the application. Puma is especially bleeding edge and looks promising.

## Development Environments

- ruby version 2.1.2
- `rvm` ruby version manager tool
- `mysql` installation
 - `brew install mysql`

**IMPORTANT** DO NOT use the `rbenv` ruby versioning tool with this project. All developers must be using the `rvm` tool found at the [RVM official website](https://rvm.io) where you can get information on the install process. Before attempting to work in the app, make sure that all remnants of `rbenv` has been removed from you shell configuration files, including `.bash_profile`, `.bashrc`, `.profile`, and any others that your shell may load on startup.

To create a local database configuration file, execute the command `cp config/database.yml.example config/database.yml`.

Set up a local mysql databases and a user for the development and test environments and modify the settings specified in the new `config/database.yml` to reflect these local databases.

### Redis
On MacOSX:

To have launchd start redis at login:
    `ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents`
Then to load redis now:
    `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist`
Or, if you don't want/need launchctl, you can just run:
    `redis-server /usr/local/etc/redis.conf`

### ImageMagick
This command line utility must be installed to paperclip to be able to manipulate image attachments to the models

CentOS: `yum install ImageMagick`

MacOSX Homebrew: `brew install imagemagick`


## General

Feel free to add tho this in any way you see fit!
