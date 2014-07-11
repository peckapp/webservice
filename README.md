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

## Monitoring Points
- Our custom API: thor.peckapp.com:3500/api/
 - nothing here as of yet... could display some public status information
- PHPMyAdmin: magni.peckapp.com/sqladmin
 - authenticate with appropriate mySQL database information
- Sideqik task monitoring: thor.peckapp.com:3500/tasks
 - will be setting up nginx http authentication for access to this site
- Kibana Log Monitoring: kibana.thor.peckapp.com
 - currently only on new thor server without DNS connection
 - will be setting up nginx http authentication for access to this site

## Production Environment

While this application will be built in development environments on the Mac OSX laptops of the developers, the production environment will be Ubuntu 12.04 running the Nginx web server. (CentOS is another more stable server linux distribution that is an optino as well. It is less feature-rich however.)

There are many options for the structure of the backend system, several of which are described in the Digital Ocean documentation linked to in the wiki pages.

### Recurring Deployment
Deployment of the rails application will be automated using [Capistrano](http://capistranorb.com) to update the server with the latest code. There will be three environments setup withing the Capistrano files that can be used to deploy the application.

#### Deploying Code
- setting up ssh keys on the server
 -
- to deploy code: `cap development deploy`
- other options from [capistrano-rails](https://github.com/capistrano/rails)
 - running migrations `cap development deploy:migrate`
 - pre-complie assets `cap development deploy:compile_assets`
 - see README for more options

#### Production Server

The production server is deployed to using similar syntax to the development server, but has two seperate environments that can be setup

- Staging
 - The staging environment allows code to be pushed and tested in an environment similar to testing, but without affecting the current production deployment of the code that users are interacting with. It is a final stage of checks before deploying to production.
- Production
 - The production environment is where the live application code exists that the mobile applications will be interacting with.

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

**IMPORTANT** DO NOT use the `rbenv` ruby versioning tool with this project. All developers must be using the `rvm` tool found at the [RVM official website](https://rvm.io) where you can get information on the install process. Before attempting to work in the app, make sure that all remnants of `rbenv` has been removed from you shell configuration files, including `.bash_profile`, `.bashrc`, `.profile`, and any others that your shell may load on startup.

To create a local database configuration file, execute the command `cp config/database.yml.example config/database.yml`.

Set up a local mysql databases and a user for the development and test environments and modify the settings specified in the new `config/database.yml` to reflect these local databases.

## Standard rails README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
