source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'
# Use postgresql as the database for Active Record
group :postgres do
	gem 'pg', '~> 0.18'
end

gem 'mysql2' # Required by thinking-sphinx, as Sphinx uses the MySQL protocol.
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
	# Call 'byebug' anywhere in the code to stop execution and get a
	# debugger console
	gem 'byebug', platform: :mri

	### ADDED BY ME
	# Style stuff
	gem 'rubocop', require: false
	gem 'simplecov', require: false
end

group :development do
	# Capistrano stuff: used for deploying
	gem 'capistrano-rails'
	gem 'capistrano-sidekiq'
	gem 'capistrano3-puma', git: 'https://github.com/seuros/capistrano-puma'

	# net-ssh requires some gems for ed25519 keys support
	# See https://github.com/net-ssh/net-ssh/issues/478
	gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
	gem 'rbnacl', '>= 3.2', '< 5.0'

	gem 'listen', '~> 3.1'
	# Spring speeds up development by keeping your application running in the
	# background. Read more: https://github.com/rails/spring
	gem 'spring'
	gem 'spring-watcher-listen', '~> 2.0.0'

	# Access an IRB console on exception pages or by using <%= console %> anywhere
	# in the code.
	gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

## ADDED BY ME

# use sidekiq for async job processing
gem 'sidekiq', '< 6'

# use clockwork fork for cron stuff
gem 'clockwork', git: 'https://github.com/Rykian/clockwork.git', tag: 'v2.0.1'
gem 'daemons' # For daemonization support

# use bootstrap for nice layouts
gem 'bootstrap', '~> 4.0.0'

# use bootstrap for front-end layout
#gem 'bootstrap-sass', '~> 3.3.6'

# use bootstrap styling for layout
gem 'bootstrap_form'

# use font awesome for nice icons
gem 'font-awesome-sass', '~> 5.0.6'

# use Devise for authentication
gem 'devise'

# use Net::LDAP for ldap authentication
gem 'net-ldap'

### API STUFF
gem 'rabl-rails'

### MiniProfiler
gem 'rack-mini-profiler'
# Addons:
gem 'flamegraph'
gem 'memory_profiler'
gem 'stackprof'

### Sentry error reporting
# Disabled by default, add an API key in secrets.yml to activate
gem 'sentry-raven', require: false

### FRONT END
gem 'jquery-datatables'

### SEARCH
# Sphinx
gem 'thinking-sphinx', '~> 3.4'
