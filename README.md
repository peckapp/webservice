# Peck Backend Ruby on Rails platform

## Purposes

This rails application serves as the API with which the mobile applications interact to store and retreive data, the management system for the database, and the platform which automates scraping for our target institutions.

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

## Development Environments

- ruby version 2.1.2
- `rvm` ruby version manager tool
- `mysql` installation

**IMPORTANT** DO NOT use the `rbenv` ruby versioning tool with this project. All developers must be using the `rvm` tool found at the [RVM official website](https://rvm.io) where you can get information on the install process. Before attempting to work in the app, make sure that all remnants of rbenv has been removed from you shell configuration files, including `.bash_profile`, `.bashrc`, `.profile`, and any others that your shell may load on startup.

Setup a mysql database and user for the development environment based on the settings specified in `config/database.yml`.

## Production Environment

While this application will be built in development environments on the Mac OSX laptops of the developers, the production environment will be Ubuntu 12.04 running the Nginx web server. (CentOS is another more stable server linux distribution that is an optino as well. It is less feature-rich however.)

There are many options for the structure of the backend system, several of which are described in the Digital Ocean documentation linked to in the wiki pages.

### System setup

#### Ruby
We will be using Ruby 2.1.2 and the various Gems specified in the gem file, with the major extensions to the standard rails dependencies falling into the catagory of scraping libraries.

#### Database Setup
We will be using the mySQL database for this rails application. The database configuration information that needs to be matched on your development machine can be found in the database.yml configuration file.

#### Automated Services
The scraping jobs will be running at automated intervals in the production environment, as well as other database analysis tasks to manage subscriptions and seggustions of events to the users. These tasks will be automated using the `clockwork` ruby gem.

### Initial production system

We will begin with a front-end application server running Nginx with passenger and running the rails application. Sitting behind this server on the private network of our hosting provider (likely to be [Digital Ocean](https://www.digitalocean.com)), will be a database server holding all of the data for our scraped events, users, and the associated media. This server will be configured in the rails application for the production setting.

Other future options include replication of the database in a master-slave relationship to ensure relability, creating a front-end cache using nginx to handle identical requests quickly while passing others along to the core rails application, and having a front-end load balancer that would pass requests to a variety of intermediate servers. We would have to look into how rails integrated with these various environments if they seem worth deploying over a single server, especially if we will be serving multiple institutions come the fall.

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
