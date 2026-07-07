# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0"
# Use PostgreSQL as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
gem "sprockets-rails"

# Bootstrap 4 is vendored as compiled CSS (vendor/assets/stylesheets/_bootstrap.scss).
# The bootstrap gem (and its autoprefixer-rails dependency) required a JavaScript
# runtime at boot, which went away along with webpacker/Node.

# Modern Rails front end: import maps + Hotwire (no Node/yarn needed)
gem "importmap-rails"
gem "stimulus-rails"
gem "turbo-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem "mini_magick", "~> 4.8"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# For Amazon S3 storage
gem "aws-sdk-s3"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "rubocop", "~> 1.7"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.9"
  gem "web-console", ">= 3.3.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem "simplecov", require: false
  # gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'

  gem "observer"
end

gem "pry-rails"

# HTML-to-PDF via headless Chromium (CDP). Replaced wicked_pdf/wkhtmltopdf:
# wkhtmltopdf is dead upstream and ships no binaries for Ubuntu 24.04+ or ARM
# (the Raspberry Pi target). Requires a chromium/chrome binary on the host.
gem "ferrum_pdf"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bcrypt"
gem "faker"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "will_paginate"
# gem 'bootstrap-will_paginate'

gem "rack-cors", require: "rack/cors"

gem "chartkick"
gem "groupdate"

# For Events calendar
gem "simple_calendar", "~> 2.4"
gem 'image_processing', '~> 1.2'
# ruby-vips is for rendering images in the Events ActionText rich text area on Heroku
# if you ever move off of Heroku, you should consider removing this gem after making sure attachments still properly
# render. I followed this post: https://stackoverflow.com/questions/70849182/could-not-open-library-vips-42-could-not-open-library-libvips-42-dylib/70849216#70849216
# to get this working. I also added the following build packs to Heroku:
# - heroku-community/apt
# - https://github.com/brandoncc/heroku-buildpack-vips
#
# Along with
# ./Aptfile # in the project root
gem "ruby-vips"

# https://sentry.io/organizations/my-happy-house/projects/my-happy-house/getting-started/ruby-rails/
gem "sentry-rails"
gem "sentry-ruby"

gem "slim-rails"
