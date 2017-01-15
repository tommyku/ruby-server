# Standard Notes Server, Ruby Implementation

This is a production-ready reference implementation of the [Standard Notes](standardnotes.org) protocol.

Standard Notes is a secure personal notes/simple blogging system.

A production client is available at https://app.neeto.io.

The Standard Notes protocol allows any client or server to communicate with one other and manage a user's notes as long as they speak the same language. Anyone can run a SN server or client.

### What is Standard Notes?
Standard Notes is a simple personal notes application with a strong focus on privacy and encryption. Notes are encrypted locally before being transmitted over the wire with a key only the user knows, and then encrypted once more server-side with a key only the server knows.

SN also allows you to create URLs for groups of notes. This means you can create a group called 'blog' and make the notes in this group publicly viewable at yourdomain.com/blog.

You can also share individual notes and customize the URL, i.e if you wrote about finding secure and private Evernote alternatives, you can share it at yourdomain.com/why-i-switched-from-evernote.

All this happens automatically and with very little effort from you.

### The Neeto Client

The Neeto app is a production client that conforms to the Standard Notes protocol. For details about the Neeto client, or for instructions on running your own client, see the [Neeto web client repo](https://github.com/neeto-project/neeto-web-client).

### Running your own server
You can run your own Standard Notes server, and use it with any SN compatible client. This allows you to have 100% control of your data. This server implementation is built with Ruby on Rails and can be deployed in minutes.

#### Getting started

**Requirements**

- Ruby 2.2+
- Rails 5
- MySQL database

**Instructions**

1. Clone the project:

	```
	git clone https://github.com/standardnotes/ruby-server.git
	```

2. Create a .env file in the project's root directory. Add environment variables (see Environment variables for full listing):

	```
	DB_HOST=localhost
	...
	```

3. Initialize project:

	```
	bundle install
	rails db:migrate
	```

4. Start the server:

	```
	rails s
	```

### Deploying to a live server

You can find instructions on deploying an SN server from scratch here:

[Deploying a Standard Notes server with Amazon EC2 and Nginx](https://github.com/standardnotes/ruby-server/wiki/Deploying-a-private-Standard-Notes-server-with-Amazon-EC2-and-Nginx)

### Environment variables


**NOTE_CONTENT_EK**

A 256 bit key for encrypting a note's content.

```
Digest::SHA256.hexdigest(SecureRandom.random_bytes(32))
```

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

## Contributing
Contributions are encouraged and welcome. Currently outstanding items:

- Test suite

## License

Licensed under the GPLv3: http://www.gnu.org/licenses/gpl-3.0.html
