# Version 2 of the Production Deployment

A single load-balancing reverse-proxr running Nginx, with a number of application servers sitting behind it running Unicorn and the rails application. Each of these accesses the mysql database server that also runs a centralized copy of redis for the sidekiq jobs. Uses the same remote database server as production deployment v1.

#### Base configuration walkthroughs
-
-

## Server setups

#### Yggdrasil

As the great tree in norse mythology that connected the worlds unto each other, so too does our load-balancing reverse proxy connect our application servers to our users.

- ports 80 and 443 (will) redirect to the main website at www.peckapp.com
- **API Port:** 7621
 - this is the port at which all of our apps will connect in order to access the API

### Application Servers

#### Eir


#### More to come!

### Database Servers

### Magni

- **MySQL Port:** tbd
- **Redis Port:** 7347
