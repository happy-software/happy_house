# Happy House

Happy House is your personal assistant that helps 
manage your home.


### Getting Started - Development

The app runs bare metal: native Ruby (via [asdf](https://asdf-vm.com)) and a
local Postgres server.

System dependencies (Debian/Ubuntu):

```bash
sudo apt install -y libpq-dev libvips postgresql
sudo snap install chromium   # headless PDF rendering via ferrum_pdf
```

Create the app's database role (once):

```bash
sudo -u postgres psql -c "CREATE ROLE happy_house LOGIN CREATEDB PASSWORD 'happy_house';"
```

Then:

```bash
asdf install            # installs the Ruby from .tool-versions
./bin/setup             # bundle install + db:prepare

# To start the application
bin/rails server
```

Database connection settings live in `.env` / `.env.test.local` (gitignored).
Create them with values matching your local Postgres:

```bash
DB_HOST="localhost"
DB_PORT="5432"          # whichever port your cluster listens on
DB_USERNAME="happy_house"
DB_PASSWORD="happy_house"
```

### Debugging with pry

Drop a `binding.pry` anywhere and run `bin/rails server` — no extra setup
needed now that the app runs directly on your machine.

### Testing

```bash
# To run every test
./test

# To run specific tests
./test <path_to_test(s)>
```

`./test` is a thin wrapper around `bundle exec rspec`. SimpleCov writes a
coverage report to `coverage/` after each run.

### Production

Deployed on Heroku (migration to self-hosted Dokku in progress). The
`Dockerfile` is kept as a deployment artifact for that migration; it is not
part of the development workflow.

Note: the `NODE_OPTIONS=--openssl-legacy-provider` config var on Heroku dates
from the webpacker era. Webpacker (and Node entirely) was removed from the
app, so that env var is obsolete and can be deleted from the Heroku app config
once this branch is deployed.
