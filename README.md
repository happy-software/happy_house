# Happy House

Happy House is your personal assistant that helps 
manage your home.


### Getting Started - Development

Once the repo is cloned:

```bash
# To start the application
docker-compose up
```

At first, you'll need to create a database and seed it. You can use
docker-compose to accomplish this.

```bash
docker-compose run --rm web rails db:create db:migrate db:seed
```

### Debugging with pry

To be able to hit breakpoints, you can run:
```bash
docker-compose up db
docker-compose run --service-ports web # in another terminal
```

See [this gist](https://gist.github.com/briankung/ebfb567d149209d2d308576a6a34e5d8#gistcomment-3186227) for more details.

### Testing

Create a file called `.env.test.local`, and add the following environment
variables:

```bash
DB_HOST="postgres"
DB_USERNAME="postgres"
```

Use the following command to run tests:

```bash
# To run every test
./test

# To run specific tests
./test <path_to_test(s)>
```

