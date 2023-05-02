FROM ruby:3.2.2

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

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
# Installing a specific version of node directly is dificult. Use `nvm` to
# install it (which installs both `node` and `npm`)
ENV NODE_VERSION 14.17.5
ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION 0.39.3

RUN mkdir -p $NVM_DIR \
  && curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && node -v \
  && npm -v

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

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
