<h1>Tasker App</h1>

<p>This is a simple task keeping application used to test a 
ruby on rails api only application. The tasker app is designed
to recognize a device ID as it's primary test was for mobile
development. However this could be expanded to a web application.</p>

<h2>Data Structures</h2>
<h3>User table:</h3>
id - integer
username - string
email - string (currently only used by signup process)
password - string - (currently not hashed ruby on rails recommending bcrypt gem)
created_at and updated at - RoR generated fields

<h3>Device Table:</h3>
id - integer
uuid - unique ID string for the device (should be created by the device)
model - model of the device could simply be browser for web app. only used during registration of new device.
token - the api token required to access any other part of 
    the api. The system uses this to connect to the user as 
    no user information is saved to the device. This should 
    be saved by the web app during the session as this is 
    required by all endpoints.
confirmed - to be used later for email based confirmation of new devices
    currently no web way to use this. May add into ruby code to confirm new device by default or add a confirm endpoint for use on testing
name - device name
user_id - key to link to user table. attaches device to user table.
created at & updated at - RoR columns

<h3>Tasks Table</h3>
id - integer
name - string title of the task
description - text description of the task
complete - bool flag to determine if task is completed
user_id - integer key to the user table 
created_at & updated_at - ror columns

<h2> API endpoints </h2>
POST '/users?username=?&password=?&email=?' - used to create a new user account will return the user_id number - planning to change this to returning the username as confirmation.
POST '/devices?uuid=?&model=?&user_id=?&name=? - used to register a new device to new user
GET '/login?username=?&password=? - used to check password for login - will not return user id number.
GET '/req_tok?username=?&uuid=? - used to request the device key needed for accessing the rest of the api. Should only be called after confirming login
GET '/new_dev?uuid=?&model=?&username=?&name=? - used to register a device to an existing user as the login system does not return the user_id which devices? endpoint requires.
GET '/chk_tkn?token=?&uuid=? - checks token against device id for auto login
GET '/tasks?token=? - gets all non completed tasks for the user_id attached to the token sent
GET '/update?token=?&time=? - gets all new tasks generated since the time sent (format: "yyyy-MM-dd HH:mm:ss.zzz"x)
GET '/tasks/show?token=?&id=? - gets the task for the task id sent (if the token matches the user attached to the task id)
GET '/tasks/check?token=?&id=? - completes the task if the task id is assigned to the same user the token is.
POST '/tasks?token=?&name=?&description=? - creates a new task under the user_id connected to the token sent.

<h2>API return values.</h2>
All contain a status key of "success" or other value. Success can be treated as confirmation.