docker-compose build
docker-compose up -d postgres
docker-compose sleep 20
docker-compose run rails rake db:setup
docker-compose up -d