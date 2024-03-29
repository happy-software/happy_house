# syntax=docker/dockerfile:1
FROM ruby:3.1.3
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -qq && apt install -y nodejs postgresql-client libvips

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

WORKDIR /myapp
COPY Gemfile* /myapp/
RUN gem install bundler && bundle install --jobs=3 --retry=3
RUN yarn install

# Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
