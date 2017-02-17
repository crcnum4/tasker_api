<h1>Tasker App</h1>

<p>This is a simple task keeping application used to test a 
ruby on rails api only application. The tasker app is designed
to recognize a device ID as it's primary test was for mobile
development. However this could be expanded to a web application.</p>

<h2>Data Structures</h2>
<h3>User table:</h3>
id - integer<br />
username - string<br />
email - string (currently only used by signup process)<br />
password - string - (currently not hashed ruby on rails recommending bcrypt gem)<br />
created_at and updated at - RoR generated fields<br />

<h3>Device Table:</h3>
id - integer<br />
uuid - unique ID string for the device (should be created by the device)<br />
model - model of the device could simply be browser for web app. only used during registration of new device.<br />
token - the api token required to access any other part of <br />
    the api. The system uses this to connect to the user as 
    no user information is saved to the device. This should 
    be saved by the web app during the session as this is 
    required by all endpoints.<br />
confirmed - to be used later for email based confirmation of new devices<br />
    currently no web way to use this. May add into ruby code to confirm new device by default or add a confirm endpoint for use on testing<br />
name - device name<br />
user_id - key to link to user table. attaches device to user table.<br />
created at & updated at - RoR columns<br />

<h3>Tasks Table</h3>
id - integer<br />
name - string title of the task<br />
description - text description of the task<br />
complete - bool flag to determine if task is completed<br />
user_id - integer key to the user table <br />
created_at & updated_at - ror columns<br />

<h2> API endpoints </h2>
POST '/users?username=?&password=?&email=?' - used to create a new user account will return the user_id number - planning to change this to returning the username as confirmation.<br />
POST '/devices?uuid=?&model=?&user_id=?&name=? - used to register a new device to new user<br />
GET '/login?username=?&password=? - used to check password for login - will not return user id number.<br />
GET '/req_tok?username=?&uuid=? - used to request the device key needed for accessing the rest of the api. Should only be called after confirming login<br />
GET '/new_dev?uuid=?&model=?&username=?&name=? - used to register a device to an existing user as the login system does not return the user_id which devices? endpoint requires.<br />
GET '/chk_tkn?token=?&uuid=? - checks token against device id for auto login<br />
GET '/tasks?token=? - gets all non completed tasks for the user_id attached to the token sent<br />
GET '/update?token=?&time=? - gets all new tasks generated since the time sent (format: "yyyy-MM-dd HH:mm:ss.zzz"x)<br />
GET '/tasks/show?token=?&id=? - gets the task for the task id sent (if the token matches the user attached to the task id)<br />
GET '/tasks/check?token=?&id=? - completes the task if the task id is assigned to the same user the token is.<br />
POST '/tasks?token=?&name=?&description=? - creates a new task under the user_id connected to the token sent.<br />

<h2>API return values.</h2>
All contain a status key of "success" or other value. Success can be treated as confirmation.

<h2>Test server</h2>
the api sometimes runs on https://rails-api-test-crcnum4.c9users.io/ however there may be times I'm running another api on this url and may not work
if you want to run your own simply clone this and run the rails s command on your system (planning to maybe create a heroku instance for those interested)