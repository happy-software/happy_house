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
docker-compose run --rm website rails db:create db:migrate db:seed
```
