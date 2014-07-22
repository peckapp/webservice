# Peck Webservice API Protocols

This file is intended to serve as documentation for the API.

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
