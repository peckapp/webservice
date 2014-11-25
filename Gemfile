source 'https://rubygems.org'

ruby '2.1.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# allows for facebook integration
gem 'koala', '~> 1.10.0rc'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# gem for calculating array statistics
gem 'descriptive-statistics'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# easy social features for the app
gem 'socialization'

# Use debugger
# gem 'debugger', group: [:development, :test]

### Push Notifications
# pushmeup should be able to handle both ios and android push notifications
gem 'pushmeup'

### Administrative Capabilities
# Active Admin for highly customizable interfaces
gem 'activeadmin', github: 'gregbell/active_admin'
# allows for easily selecting a country in admin interface
gem 'country-select'
# allows for data to be uploaded, useful for transferring scraping settings
gem 'active_admin_importable'
# allows for a better date time picker
gem 'just-datetime-picker'

### FILE MANAGEMENT
# Paperclip for handling larger files, mostly user-uploaded images: https://github.com/thoughtbot/paperclip
gem 'paperclip', '~> 4.2.0'
# allows for background job-based post-processing
gem 'delayed_paperclip'
# allows paperclip to interface with amazon s3
gem 'aws-sdk'

### DATABASE INTERACTIONS
# ransack for more powerful database queries. This branch supports only rails 4.1 https://github.com/activerecord-hackery/ransack/tree/rails-4.1
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'

### SCRAPING
# Feedjira provides a powerful and dead simple RSS scraping tool
gem 'feedjira'
# nokogiri HTML, XML, SAX, and Reader parser. can search using XPath or CSS selectors
gem 'nokogiri'
# mechanize for traversing webpages and links
gem 'mechanize'
# Restclient for gathering pages
gem 'rest-client'
# watir-webdriver as a selinium wrapper: http://watirwebdriver.com
gem 'watir-webdriver'
# allows selenium to be run without a head GUI
gem 'headless'

### Job Scheduling
# Sidekiq for running background jobs in seperate threads - https://github.com/mperham/sidekiq
gem 'sidekiq'
# sidetiq for scheduling those bacground jobs - https://github.com/tobiassvn/sidetiq
gem 'sidetiq'
# gems for the sidekiq interface
gem 'sinatra', require: false
gem 'slim'
# allows for use of unique jobs for things that shouldn't be run more than once
gem 'sidekiq-unique-jobs'

### API
# rabl rails for api
gem 'rabl-rails'

### UTILITIES
# Bloom Filter for crawlers to keep track of which pages have been traversed
gem 'bloomfilter-rb', '~> 2.1.1'
# validating dates
gem 'validates_timeliness', '~> 3.0'
# authentication gem, used by ActiveAdmin
gem 'devise', '~> 3.2.4'
# used by the cocaine dependency of Paperclip to allow high-memory requirement
# operations to be performed without forking, *hopefully* eliminating some out of memory errors
gem 'posix-spawn'
# allows for logs to be silenced, helpful for new relic polling calls
gem 'silencer'

### HOSTED SERVER MONITORING
gem 'newrelic_rpm'

### Production Server Deployments using Unicorn
group :production do
  # unicorn interface gem: http://unicorn.bogomips.org
  gem 'unicorn'
  # dalli for interfacing with memcached
  gem 'dalli'
  ## apparently provides 20-30% performance boost to dalli ##
  # gem 'kgio'
  # included for heroku deployment
  gem 'rails_12factor'
end

### Development-specific gems
group :development do
  # Capistrano for deployment to server: https://github.com/capistrano/capistrano
  gem 'capistrano', '~> 3.2.1'
  # rvm integration on deploys: https://github.com/capistrano/rvm
  gem 'capistrano-rvm'
  # installing necessary gems on deploys: http://github.com/capistrano/bundler
  gem 'capistrano-bundler', '~> 1.1.2'
  # rails-related operations: https://github.com/capistrano/rails
  gem 'capistrano-rails', '~> 1.1'
  # sidekiq task-management: https://github.com/seuros/capistrano-sidekiq
  gem 'capistrano-sidekiq'
  # unicorn gem for production deployments: https://github.com/tablexi/capistrano3-unicorn
  gem 'capistrano3-unicorn'

  # database visualization
  gem 'rails-erd'
  # primitive gui display of database models
  gem 'hirb', '~> 0.7.2'
  # used to easily generate fake data
  gem 'faker', '~> 1.4.2'
  # Mass populate an Active Record database
  gem 'populator', '~> 1.0.0'
end
