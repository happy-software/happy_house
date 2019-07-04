# Use an official Ruby runtime as a parent image
FROM ruby:2.5.1
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libpq-dev nodejs jq

# Set the working directory to /app
RUN mkdir /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in Gemfile
WORKDIR /app
RUN bundle install --binstubs

# Make port 3000 available to the world outside this container
ENV PORT 3000
EXPOSE $PORT
ENTRYPOINT ["bin/entrypoint.sh"]

LABEL maintainer="Hebron George <hebrontgeorge@gmail.com>"
# Run server when the container launches
CMD puma -C config/puma.rb
