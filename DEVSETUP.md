# Dev Setup 
## Requirements
#### Server
- Ruby w. RubyGems
- Bundler
- *(Optional)* Your own PostgreSQL DB
- *(Optional)* Docker + Docker-Compose
#### Frontend
- NodeJS
- NPM
#### Client
- Ruby

### Server (with own PostgreSQL DB)
```bash
cd server/
bundle install
rails db:setup
rails s
```

### Server (automatically spin up PostgreSQL DB)
```bash
cd server/
docker-compose build .
docker-compose up
```
Then access on localhost:3000

### Frontend
```bash
cd frontend
npm install
npm run dev
```
Then access on localhost:8080

### Client
No setup, just run 'ruby client.rb' with a projectID as an optional first argument. (Requires JWT auth key being set up) 
