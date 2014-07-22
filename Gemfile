source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
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

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use debugger
# gem 'debugger', group: [:development, :test]


### Administrative Capabilities
# Active Admin for highly customizable interfaces
gem 'activeadmin', github: 'gregbell/active_admin'



### FILE MANAGEMENT
# Paperclip for handling larger files, mostly user-uploaded images: https://github.com/thoughtbot/paperclip
gem 'paperclip', '~> 4.2.0'


### DATABASE INTERACTIONS
# ransack for more powerful database queries. This branch supports only rails 4.1 https://github.com/activerecord-hackery/ransack/tree/rails-4.1
gem "ransack", github: "activerecord-hackery/ransack", branch: "rails-4.1"


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


### Job Scheduling
# Sidekiq for running background jobs in seperate threads - https://github.com/mperham/sidekiq
gem 'sidekiq'
# sidetiq for scheduling those bacground jobs - https://github.com/tobiassvn/sidetiq
gem 'sidetiq'
# gems for the sidekiq interface
gem 'sinatra', require: false
gem 'slim'


### API
# rabl rails for api
gem 'rabl-rails'


### UTILITIES
# Bloom Filter for crawlers to keep track of which pages have been traversed
gem 'bloomfilter-rb', '~> 2.1.1'

# primitive gui display of database models
gem 'hirb', '~> 0.7.2'

# validating dates
gem 'validates_timeliness', '~> 3.0'

gem 'devise', '~> 3.2.4'


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

    # database visualization
    gem 'rails-erd'
end
