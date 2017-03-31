# Standard File Server, Ruby Implementation

This is a production-ready reference implementation of the [Standard File](https://standardfile.org/) protocol.

A production client is available at https://app.standardnotes.org

### Running your own server
You can run your own Standard File server, and use it with any SF compatible client (like Standard Notes). This allows you to have 100% control of your data. This server implementation is built with Ruby on Rails and can be deployed in minutes.

#### Getting started

**Requirements**

- Ruby 2.2+
- Rails 5
- MySQL database

**Instructions**

1. Clone the project:

	```
	git clone https://github.com/standardfile/ruby-server.git
	```

2. Create a .env file in the project's root directory. Add environment variables (see Environment variables for full listing):

	```
	DB_HOST=localhost
	...
	```

3. Initialize project:

	```
	bundle install
	rails db:create db:migrate
	```

4. Start the server:

	```
	rails s
	```

### Deploying to a live server

You can find instructions on deploying an SN server from scratch here:

[Deploying a Standard File server with Amazon EC2 and Nginx](https://github.com/standardfile/ruby-server/wiki/Deploying-a-private-Standard-File-server-with-Amazon-EC2-and-Nginx)

### Deploying to a live server with Docker

**On production server**

1. Clone the project
   ``` bash
   $ git clone https://github.com/tommyku/ruby-server
   ```

2. Create .env.{web|db}.production files in the project's root directory. Add environment variables (see Environment variables for full listing):
   ```
   DB_HOST=db
   ...
   ```

3. Build and start the services:
   ``` bash
   $ docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
   ```

4. Login to the `app` service to initialize project:
   ``` bash
   $ docker ps
   $ docker exec -it {container ID of the app service} /bin/bash
   app> bundle exec rake db:create db:migrate
   ```

5. Access the server from 3000 port or 80 port
  ``` bash
  $ curl {domain name}
  <!doctype html>
  <html>
    ...
    <body>
      <h1> Hi! You're not supposed to be here. </h1>

      <p> You might be looking for the <a href="https://app.standardnotes.org"> Standard Notes Web App</a> or the main <a href="https://standardnotes.org"> Standard Notes Website</a>. </p>

    </body>
  </html>
  ```

### Environment variables

**SECRET_KEY_BASE**

Rails secret key used only in production environment

**RAILS_ENV***

Rails environment, set it to `production` on production server.

**DB_HOST**

Database host.

**DB_PORT**

Database port. 3306 is standard.

**DB_DATABASE**

Database name.

**DB_USERNAME**

Database username.

**DB_PASSWORD**

Database password.

#### Optional environment variables if you want to use Dropbox

**HOST**

Server url

**DROPBOX_CLIENT_ID**

Dropbox client id

**DROPBOX_CLIENT_SECRET**

Dropbox client secret

## Contributing
Contributions are encouraged and welcome. Currently outstanding items:

- Test suite

## License

Licensed under the GPLv3: http://www.gnu.org/licenses/gpl-3.0.html
