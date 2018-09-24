# Use an official Ruby runtime as a parent image
FROM ruby:2.4.1
RUN apt-get update && apt-get upgrade -y
#RUN apt-get install -y postgresql-9.4 
RUN apt-get install -y libpq-dev nodejs jq
RUN gem install rails

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in Gemfile
RUN bundle install

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run server when the container launches
CMD ["rails", "server"] 
