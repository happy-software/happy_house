LABEL maintainer="Hebron George <hebrontgeorge@gmail.com>"

# Use an official Ruby runtime as a parent image
FROM ruby:2.4.1
RUN apt-get update && apt-get upgrade -y
#RUN apt-get install -y postgresql-9.4 
RUN apt-get install -y libpq-dev nodejs jq
RUN gem install rails

# Set the working directory to /app
RUN mkdir /app
WORKDIR /app

# Install any needed packages specified in Gemfile
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run server when the container launches
CMD puma -C config/puma.rb
