# Use an official Ruby runtime as a parent image
FROM ruby:2.5.1
LABEL maintainer="Hebron George <hebrontgeorge@gmail.com>"
# Run server when the container launches
CMD puma -C config/puma.rb
ENTRYPOINT ["bin/entrypoint.sh"]

# Make port 3000 available to the world outside this container
ENV PORT="3000" \
    APP_DIR="/app/"
EXPOSE $PORT
RUN mkdir $APP_DIR
WORKDIR $APP_DIR

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libpq-dev nodejs jq

# Try doing the bundle stuff first
COPY Gemfile Gemfile.lock $APP_DIR
RUN bundle install

# Copy the current directory contents into the container at /app
COPY . $APP_DIR
