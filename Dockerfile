FROM ruby:3.0.0

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Configure working directory
RUN mkdir /app
WORKDIR /app

COPY entrypoint.sh /usr/bin/
COPY Gemfile Gemfile.lock /app/
COPY package.json yarn.lock /app/

#
# Install Dependencies
#
#   * curl is used for slack notifications in pre/post deploy hooks
#   * libjemalloc2 is a malloc replacement for MRI Ruby (see entrypoint.sh)
#   * postgresql-client for pg_isready command
#

# Ruby
RUN apt-get -q update \
  && apt-get install -q -y --no-install-recommends git build-essential libpq-dev curl postgresql-client libjemalloc2 \
  && bundle config set path /bundle \
  && bundle install \
  # Clean up installed packages we no longer need and the apt cache
  && apt-get -q -y remove --autoremove gcc make \
  && apt-get clean -y

# NodeJS
RUN mkdir -p /usr/local/nvm \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install -y nodejs \
  && node -v \
  && npm -v

# Yarn
RUN npm install -g yarn \
  && yarn install --check-files --pure-lockfile

# Install Chrome
# Google does not make it easy to install versions outside of the latest stable
# See: https://stackoverflow.com/a/56842239/2490003
RUN curl -LO  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver v112
# This needs to be periodically updated to match the version of Google Chrome
# installed above
RUN apt install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev \
  && wget https://chromedriver.storage.googleapis.com/112.0.5615.49/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
  && rm chromedriver_linux64.zip \
  # Clean up
  && apt-get -q -y remove --autoremove gcc make \
  && apt-get clean -y

COPY . .

ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-p", "7000", "-b", "0.0.0.0"]
