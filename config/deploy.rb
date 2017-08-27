# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "k2"
set :repo_url, "git@github.com:cpps/k2.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/k2/"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_files, 'config/thinking_sphinx.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

### RAILS
# Keep the last 3 versions of assets
set :keep_assets, 3

# Migrations are done on the app server. Not that it matters. For now
set :migration_role, :app

# Oh, and only do migrations if the files were touched
set :conditionally_migrate, true

### PUMA
# We use Active Record, so we need to enable this
set :puma_init_active_record, true

### SIDEKIQ
set :sidekiq_queue, ["default"]

### CLOCKWORK
after "deploy:published", "clockwork:restart"

