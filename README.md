# Neeto

Neeto is a simple and secure personal notes/blogging system.

You can see a live demo at https://app.neeto.io.

Neeto is decentralized, which means anyone can run a Neeto server or client. The "official" client is available at app.neeto.io, and by default uses the main Neeto server. However, this option can be overridden to use a server of your choosing.

### What is Neeto?
Neeto is a simple personal notes application with a strong focus on privacy and encryption. Notes are encrypted locally before transmitting over the wire with a key based only the user knows, and then encrypted once more server-side with a key only the server knows.

Neeto also allows you to create URLs for groups of notes. This means you can create a group called 'blog' and make the notes in this group publicly viewable at yourdomain.com/blog.

You can also share individual notes and customize the URL, i.e if you wrote about finding secure and private Evernote alternatives, you can share it at yourdomain.com/why-i-switched-from-evernote.

All this happens automatically and with very little effort from you.

### The Neeto Client
**Features**

- Grouping of notes
- Auto-save
- Markdown editor
- Easy publishing/sharing of groups or individual notes.
- Local encryption.
- Quick filtering
- Full screen writing
- Simple UI

For details about the "official" Neeto client, please see the [Neeto web client repo](https://github.com/neeto-project/neeto-web-client).

### Running your own server
You can run your own Neeto server, which allows you to have 100% control of your data. The Neeto server is built with Ruby on Rails and can be deployed in minutes. You can then use your server with any client that supports the Neeto protocol.

#### Getting started

**Requirements**

- Ruby 2.2+
- Rails 5
- MySQL database

**Instructions**

1. Clone the project:

	```
	git clone https://github.com/neeto-project/neeto-server.git
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

You can find instructions on deploying a Neeto server from scratch here:

[Deploying a Neeto server with Amazon EC2 and Nginx](https://github.com/neeto-project/neeto-server/wiki/Installing-a-private-Neeto-server-on-Amazon-EC2)

### Environment variables


**NOTE_NAME_EK**

A 256 bit key for encrypting a note's title. You can generate a random 256 bit key in a Rails console or Ruby Interpreter using:

```
Digest::SHA256.hexdigest(SecureRandom.random_bytes(32))
```


**NOTE_CONTENT_EK**

A 256 bit key for encrypting a note's content.


**NOTE_LOCAL_CONTENT_EK**

A 256 bit key for encrypting a note's locally encrypted content. (i.e a note is encrypted locally and then encrypted again on the server using different keys.)


**ROOT_PRESENTATION_PATH**

*Optional/mutually exclusive with ROOT_REDIRECT.*

The root_path of the presentation that should be displayed when visiting the server's root.


**ROOT_REDIRECT**

*Optional/mutually exclusive with ROOT_PRESENTATION_PATH.*

A 256 bit key for encrypting a note's content.


**NEETO_PRESENTATION_HOST**

The base URL for shared notes. i.e notes.example.com/
This URL must eventually resolve to where your Neeto server is located.
i.e your API is available at api.example.com but should be publicly presented through notes.example.com, however, both URLs must point to the same server.

*Note: trailing slash is required.*


**NEETO_SINGLE_USER_MODE**

*Optional*

Default is true. If you're running a personal server, and want to prohibit strangers from registering for an account with your server, you should set this true. If you wish to create a public server that allows user registration and multiple user notes, set this to false.


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
- Native clients

## License
Neeto is released under the MIT License.
