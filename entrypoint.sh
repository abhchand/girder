#!/bin/bash

echo "Installing/Checking ruby dependencies"
bundle config set path /bundle
bundle check || bundle install

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Ping PostgreSQL server to see if it's ready to accept connection
#
test_postgres_connection () {
  # https://stackoverflow.com/a/55783574
  PGPASSWORD=$POSTGRES_PASSWORD pg_isready \
    --host=$POSTGRES_HOST \
    --port=$POSTGRES_PORT \
    --username=$POSTGRES_USER \
    > /dev/null

  echo "$?"
}

# Block execution until PostgreSQL server is ready.
#
# Retry 5 times
#
until_postgres_ready () {
  local retries=0

  until [[ $(test_postgres_connection) = 0 ]]; do
    echo 'Testing PostgreSQL connection'

    sleep 15

    retries=$((++retries))

    if [[ $retries -gt 4 ]]; then
      echo 'PostgreSQL connection cannot be established after 5 attempts'
      return 1
    fi
  done

  echo 'PostgreSQL connection established'
}

retries=0
until_postgres_ready

version=$(bundle exec rake db:version)

if [[ $? -eq 0 ]] && [[ $version != "Current version: 0" ]]; then
  echo "Database exists: running migrations"
  bundle exec rake db:migrate
else
  echo "No database setup: running setup"
  bundle exec rake db:setup
fi

# Make sure to bail out if db:setup or db:migrate failed
if [[ $? != 0 ]]; then
  exit 1
fi

# Find architecture-appropriate jemalloc library path
export LD_PRELOAD=$(dpkg -L libjemalloc2 | grep libjemalloc.so.2)

# Then exec the container's main process (what's set as CMD in the Dockerfile).
echo "ready to take-off 🚀"
if [ $# -gt 0 ]; then
  bundle exec "$@"
fi
