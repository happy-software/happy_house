# syntax=docker/dockerfile:1
FROM ruby:3.1.3
RUN apt update -qq && apt install -y postgresql-client libvips

WORKDIR /myapp
COPY Gemfile* /myapp/
RUN gem install bundler && bundle install --jobs=3 --retry=3

# Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
