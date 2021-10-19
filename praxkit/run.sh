 docker-compose -f stack.yml up --remove-orphans -d
mix ecto.create
mix phx.server

# shutdown database manually
## docker-compose down

# remove container
## docker-compose -f stack.yml rm 
# remove volume
## docker volume rm praxkit_postgres-data