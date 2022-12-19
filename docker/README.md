Build the app thus:
```
docker compose --file .\docker\docker-compose.yml --project-directory . build
```

Run the application:
```
docker compose --file .\docker\docker-compose.yml --project-directory . up
```

Add certificates, nginx conf and seafile conf in volume maps.
