# Peck Backend Ruby on Rails platform

## Purposes

This rails application serves as the API with which the mobile applications interact to store and retreive data, the management system for the database, and the platform which automates scraping for our target institutions.

- API
 - Allows for structured and protected interactions between the app and the content stored within the database
- Database
 - Created through migrations and manipulated through models standard for the Rails platform
- Scraping
 - automated, customized tasks that retreive data from member institutions at regular and dynamic time intervals to ensure that the most up-to-date information is being presented to users
 - accuracy and reliability of this system is absolutely key to our service

## Production environment

While this application will be largely run in development environments on the Mac OSX laptops of the developers, the production environment will be Ubuntu 12.04 running the Nginx web server.

There are many options for the structure of the backend system, several of which are described in the digital-ocean documentation linked to in the wiki pages.

### System setup

#### Ruby
We plan to be using Ruby 2.1.1 and the various Gems specified in the gem file, with the major extensions to the standard rails dependencies falling into the catagory of scraping libraries.

#### Database Setup
We will be using the mySQL database for this rails application. The database configuration information that needs to be matched on your development machine can be found in the database.yml configuration file.

#### Automated Services
The scraping jobs will be running at automated intervals in the production environment, as well as other database analysis tasks to manage subscriptions and seggustions of events to the users.

### Our initial production system

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
