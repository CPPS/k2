# README

Welcome to the K2 source code repository! K2 is an application designed to 
help people find the problems they like best in an overcrowded instance of 
DomJudge. For instructions on how to deploy K2, please continue reading.

The instance run by Henk, linked against the CPPS server, can be found [here](https://k2.henkvdlaan.ga)

# System dependencies

K2 requires the following packages:
- Ruby 2.3.3 (Ruby >= 2.2 could also work, but is unsupported)
	- Installation using a version manager such as RVM is unsupported
	- Usage of JRuby or Rubinius is discouraged.
	- PostgreSQL (Tested: 9.5.5)
	- NodeJS (Tested: 4.6.1, used for compiling CoffeeScript)
- Redis (Tested: 3.2.5)
	- When deploying in production, we recommend using a reverse proxy like Nginx
	and Capistrano to ease updating at a later date.

K2 has been tested on Gentoo based systems exclusively, but could work in other
distributions. No support can be provided for non-Linux based systems.

# Configuration

In this guide, I assume that you will be running a production environment.
If you want to run a development environment instead, please substitute
"production" with "development".

I also assume that you will be running PostgreSQL and Redis on the same system
and on the default ports. All commands listed in this guide are shown in 
`monospace font`.

- First, install all required ruby gems using bundler: `bundler install`. This
will take a while, feel free to take a toilet break.

## Database Configuration
Create an user in PostgreSQL, give it a password and give that user a database:
	- Ensure that PostgreSQL has been set up and configured according to
	the instructions provided by your distribution and that the database
	has been started: `sudo /etc/init.d/postgresql-9.5 start` for systems
	using OpenRC.
	- First, open an interactive session: `sudo -u postgres psql`
	- When you are in a session, create an user and an database: `CREATE USER k2; 
	CREATE DATABASE k2_production WITH OWNER k2;`
	- Finally, give the newly created user an password: `\password k2`
	- Write down the username, database and password you have entered
	- Enter `\q` to leave the interactive session with Postgres
	- Copy the example database file into place: `cp config/database.yml.example
	config/database.yml`
	- Open the config/database.yml file, enter your database username, password and
	database name under the "production" environment. Please note that YAML
	disallows usage of tabs in these files and will crash violently if it finds
	one.

## Final configuration
	- Copy the example secrets.yml file into place: `cp config/secrets.yml.example
	config/secrets.yml`
	- Generate an new secret using `bundle exec rails secret`. Paste it in the
	config/secrets.yml file.
	- Review the config/puma.rb file and check if it meets your requirements.
	- If you want to run a production instance, you need to run the
	  following step: `RAILS_ENV=production bundle exec rails
	  assets:precompile`. This will convert the assets into a cacheable
	  bundle. This can take a while, blame Sass and Coffeescript.
## Database initialization

We can now start initializing the database:
	- First we need to load the migrations into the database `RAILS_ENV=production
	bundle exec rake db:migrate`. If this fails, double check your database
	configuration. Oh, and read the stacktrace.
	- Please start Redis. On OpenRC-based systems, this is done using
	`/etc/init.d/redis start`
	- We can now start Sidekiq. Sidekiq will manage background jobs. Do not start
	clockwork yet, because doing so might cause your initial import to take
	longer than necessary. Execute `bundle exec sidekiq -q default` in a seperate 
	tab to make shutting it down easier.
	- We can now start with loading the dataset into memory. Open an Rails Console
	using the following command: `RAILS_ENV=production bundle exec rails
	console`. The following commands will be done inside this shell.
	- We need to create an server object to pull data from. For simplicity's sake,
	we will call it "s". `s = Server.new`
	- For K2 to find DomJudge and send appropriate data to the user, we need to set
	various properties. The properties given represent the demo scoreboard
		- `name` should be something familiar to describe the server: `s.name = "HQ"`
		- `url` is the link to the public scoreboard: `s.url =
		"https://expressfaxanyway.tk/domjudge/"`
		- `api_type` needs to be set to "domjudge" for the moment, since DomJudge is
		the only tracker currently supported: `s.api_type = "domjudge"`
		- `api_endpoint` is the endpoint used by K2 to read the api from. Usually
		this is the url with "api/" attached to it: `s.api_endpoint = s.url +
		"api/"
		- `last_submission` is used to limit submissions received from DomJudge. For
		the initial value, 0 is appropriate. `s.last_submission = 0`
	- Iff you have entered all these properties, you can now save the server
	object: `s.save!`. If it returns true, you can now proceed with loading in
	the dataset.

## Dataset import
	- Make sure you are still inside the rails console: Do `RAILS_ENV=production 
	  bundle exec rails console` if you are not.
	- First update the users: `AccountUpdateJob.perform_now`
	- Second, update the problem set: `ProblemUpdateJob.perform_now`
	- Finally, update the submission list. This requires the other jobs to
	  have finished, otherwise this one could fail.
	  `SubmissionUpdateJob.perform_now`. Note that this job will take
	  significantly longer than the two others, due to the necessary
	  complexity involved. Feel free to get a coffee.
	- After this step is done, you are now able to start K2. You can exit
	  from the Rails console using exit, quit or Control+D, whatever you
	  prefer. Take that, Python!

## Reverse Proxying setup

An example Nginx configuration file has been provided in the root of this 
repository. It needs to be adapted and placed in your Nginx configuration file, 
which is located in `/etc/nginx/nginx.conf`. Please change the domain name to 
your own and check if the socket location for Puma/Rails is correctly configured.

Reverse proxying is recommended for production environments only.

# Services

To start Rails, execute `bundle exec rails server` and depending on the weather
outside and the configuration, the service will start on either port 5000 or 3000, 
which will be indicated in the startup log.

Sidekiq: `bundle exec sidekiq -q default`
Clockwork: `bundle exec clockwork clock.rb`. 

# Files provided
The interesting files and folders have been highlighted in **bold**.

- `app`: Entire application
	- `assets`: Javascript and css files
	- `channels`: ActionCable channels, not used.
	- **`controllers`**: The C in MVC. Subfolder "api" responsible for API-requests
	- `helpers`: Helper functions used almost everywhere.
	- **`jobs`**: Background jobs. Interesting stuff.
	- `mailers`: Not used.
	- **`models`**: The M in MVC.
	- **`views`**: The V in MVC. All files ending on .erb will be processed by ERB 
	first before being served, all files ending on .rabl will be processed by 
	RABL before being serialized as JSON or XML.
- `Capfile`: Capistrano configuration file. Useful for automated deployment.
- `clock.rb`: Clockwork configuration file. Useful in production instances for
  regularly updating the data
- `config`: Configuration files
	- `database.yml`: Database configuration
	- `deploy[.rb]`: Capistrano config files for capistrano
	- `secrets.yml`: Cookie secrets file
	- **`routes.rb`**: List of all routes
- `db`: Database configuration files
	- **`schema.rb`**: Ruby representation of the entire database schema
	- `migrate`: Individual migrations
- `Gemfile`: List of all dependencies

