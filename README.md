# Girder

The application and all of its services run inside docker containers, as defined in `docker-compose.yml`.

The `bin/app` script provides command line helpers to interact with and run commands inside the docker container ecosystem. Most commands will require that the application backend be running for the command to work.

# Development

```bash
# Run the BackEnd
docker-compose up

# Run the FrontEnd
nvm use
yarn install
yarn run dev
```

Visit [http://localhost:3000/](http://localhost:7000/)

For more detail on how the frontend works, see [the frontend `README`](app/frontend/README.md).

# Test

```bash
# BackEnd Tests (requires backend running)
bin/app rspec

# FrontEnd Tests
yarn run test
```

# Code Formatting & Linting

```shell
# Run linters
yarn run prettier
yarn run lint:ruby
yarn run lint:js
yarn run lint:css

# Auto-fix any issues
yarn run prettier:fix
yarn run lint:ruby:fix
yarn run lint:js:fix
yarn run lint:css:fix
```
