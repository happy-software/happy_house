# syntax=docker/dockerfile:1
FROM ruby:2.5.1
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler -v 2.1.4
ENV BUNDLER_VERSION="2.1.4"
RUN bundle install

# Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

ENV DB_USERNAME="postgres"
ENV DB_PASSWORD="password"
ENV DB_HOST="db"

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
