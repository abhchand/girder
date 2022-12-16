# girder

[![Build Status](https://github.com/abhchand/girder/badges/master/build.svg)](https://github.com/abhchand/girder/pipelines)


# Quick-Start

Create environment file, following instructions inside the file:

```bash
cp .env.development.sample .env.development
```

Build the app:

```bash

# BackEnd
docker-compose up

# FrontEnd
nvm use
yarn install
yarn run dev
```

Visit [http://localhost:3000/](http://localhost:7000/)

## The FrontEnd

* On `development`/`test` the frontend is served from a running `webpack-dev-server` instance.
* On `production` the assets are compiled into `public/` (by running `yarn run build:prod` on Semaphore CI) and served statically.


### Githooks

Install githooks, if you plan on committing or contributing to Girder.

The script below registers a new hook under the `.git/hooks/pre-commit` which will run all the linters and stylers under `contrib/hooks/scripts/*`.

```
bin/install-githooks
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
