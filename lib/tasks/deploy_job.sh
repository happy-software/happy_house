#!/usr/bin/env bash

# Run Migrations
bundle exec rails db:migrate

# Send deploy notification to Honeybadger
sh lib/tasks/honeybadger_deploy_notification.sh
