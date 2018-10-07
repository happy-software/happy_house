# Happy House

Happy House is your personal assistant that helps 
manage your home.


### Getting Started - Development

Once the repo is cloned:

```bash
docker-compose up &
docker-compose run website rails db:create
docker-compose run website rails db:migrate
docker-compose run website rails db:seed
```
