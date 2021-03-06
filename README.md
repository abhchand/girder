# girder

[![Build Status](https://github.com/abhchand/girder/badges/master/build.svg)](https://github.com/abhchand/girder/pipelines)


# Development / Test Setup

Create an environment file using the provided template. Follow the instructions inside that file to set the environment.

```
cp .env.development.sample .env.development
```

Install dependencies:

```
bundle install
yarn install
```

Install [Redis](https://redis.io), used for job queueing and caching

```
brew install redis                  # OSX
sudo apt install redis-server       # Debian / Ubuntu
```

Install githooks, if you plan on committing or contributing to Girder.
The script below registers a new hook under the `.git/hooks/pre-commit` which will run all the linters and stylers under `contrib/hooks/scripts/*`.

```
bin/install-githooks
```

Build the schemas:

```
# Creates both development and test databases
RAILS_ENV=development bundle exec rake db:create

# Doesnt migrate test schema, but that's done automatically
# at the start of each test run anyway
RAILS_ENV=development bundle exec rake db:migrate

# Seed the local environment
RAILS_ENV=development bundle exec rake db:seed
```

Run tests (if you want to):

```
bin/rspec
```

Create an admin account:

```
bundle exec rake girder:admin:create['FirstName','LastName','email@example.com','password']
```

Start the app:

```
bin/foreman start -f Procfile.dev
```

# Production (Docker)

Create and fill out env files

```
cp .env.production.sample .env.production
cp .env.dockercompose.sample .env.dockercompose
```

Build

```
docker-compose up --build --no-start

# Only required on first build
docker-compose run --rm web bundle exec rake db:create

docker-compose run --rm web bundle exec rake db:migrate
docker-compose run --rm web bundle exec rake assets:precompile

# Optional (one-time)
docker-compose run --rm web bundle exec rake girder:admin:create['FirstName','LastName','email@example.com','password']
```

Start app

```
docker-compose start
```

The app listens for incoming HTTP requests on a unix socket. This can be setup via Nginx or similar reverse proxies.

To test it's working, enter the running container and make a test HTTP request:

```
docker exec -i -t girder_web_1 /bin/bash
> curl --unix-socket /app/tmp/sockets/puma.sock http://localhost/
```

Stop app

```
docker-compose stop
```

# Production (Automated)

The above production build and deploy can be automated with the [girder-ansible](https://gitlab.com/girder/girder-ansible) repo.

Follow the instructions in there to provision the server.

Then add a new git remote and push changes to create a new build

```
git remote add production ssh://git@XXXXX:/opt/git/girder.git

# Commit new changes

git push production master
```
