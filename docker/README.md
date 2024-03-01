Build the app thus:
```
docker compose --file .\docker\docker-compose.yml --project-directory . build
```

Run the application:
```
docker compose --file .\docker\docker-compose.yml --project-directory . up
```

Poetry update inside docker container
Update mysql
update consul-template

Add certificates, nginx conf and seafile conf in volume maps.
