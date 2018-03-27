if [ "$1" != "prod" ]; then
    echo "Starting dev"
    docker-compose build
    docker-compose up -d postgres
    sleep 20
    docker-compose run rails rake db:setup
    docker-compose up -d
else
    echo "Starting prod"
    docker-compose down
    docker-compose -f docker-compose_site.yml build --no-cache
    docker-compose -f docker-compose_site.yml up -d postgres
    sleep 20
    docker-compose -f docker-compose_site.yml run rails /bin/bash -c "rails db:create db:migrate RAILS_ENV=production"
    docker-compose -f docker-compose_site.yml up -d
    cd ../ui/
    npm run build
    cd dist 
    docker rmi -f httpd
    docker run -d -p 8080:80 -e VIRTUAL_HOST=ui.dependensee.tech -e LETSENCRYPT_HOST=ui.dependensee.tech -e LETSENCRYPT_EMAIL=contact@ui.dependensee.tech --network=webproxy -v "$PWD":/usr/local/apache2/htdocs/ httpd
fi
