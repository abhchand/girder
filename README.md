# Girder

# Development

```bash
# BackEnd
docker compose up

# FrontEnd
nvm use
yarn install
yarn run dev
```

Visit [http://localhost:7000/](http://localhost:7000/)

For more detail on how the frontend works, see [the frontend `README`](app/frontend/README.md).

## Sidekiq

Sidekiq client doesn't run by default, so any enqueued jobs just wait in the queue to be processed.

You can start Sidekiq with:

```bash
bin/app run bundle exec sidekiq
```

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
