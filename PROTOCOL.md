# Peck Webservice API Protocols

This file is intended to serve as documentation for the API.

### 

1. Public action for user not logged in.
  - Retrieve session info for user id. Query database if nil.
  - Check provided api key against stored api key.

2. Validated user logging in.
  - All public checks from 1.
  - Check email and password against datavase values.
  - If success: hand out authentication token and store in database.
  - Else, error (increment # of failed attempts in session)

3. Logged in performing private action
  - All public checks from 1.
  - Verify authentication token sent in with request against session authentication token.

4. Logged-in user logging out
  - Destroy session
  - Clear authentication token from database.

## REST Routing

### Index:

GET api/simple_events

### Show:

GET api/simple_events/:id

### Create:

POST api/simple_events

#### NOTES ON CREATE USER:
- Check if current user device token (UDT) already has a registered user associated to it
  - UDT is in the DB:
    - matching user has not yet registered
      - ask user if they would like to continue using the app with the previous user's preferences
        - If they wish to use that user's preferences: load those preferences
        - Otherwise: create new annonymous user (with new ID)
    - matching user is already registered
      - ask user if they would like to continue using the app with the previous user's preferences
      - make sure to include name of that previously created user
        - If they wish to use that user's preferences: request login information
        - Otherwise: create new annonymous user (with new ID)
  - UDT is not in the DB:
    - create new anonymous user

### Update:

PATCH api/simple_events/:id

### Destroy:

DELETE api/simple_events/:id
