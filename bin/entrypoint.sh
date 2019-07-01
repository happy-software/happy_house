#!/bin/bash

set -e
set +x

if [ "$1" = 'web' ]; then
  exec bundle exec puma -C config/puma.rb
elif [ "$1" = 'prod_web' ]; then
  bundle exec rake assets:precompile
  exec bundle exec puma -C config/puma.rb
elif [ "$1" = 'sidekiq' ]; then
  exec bundle exec sidekiq
elif [ "$1" = 'db_migrate' ]; then
  exec bundle exec rake db:migrate
else
  exec $@
fi
