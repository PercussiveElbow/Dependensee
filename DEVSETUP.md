# Dev Setup 
## Requirements
#### Server
- Ruby w. RubyGems
- Bundler
- *(Optional)* Your own PostgreSQL DB
- *(Optional)* Docker + Docker-Compose
#### UI
- NodeJS
- NPM
#### Client
- Ruby

### Server (with own PostgreSQL DB)
Edit config/database.yml to point to your DB
```bash
cd server/
bundle install
rails db:setup
rails s
```

### Server (automatically spin up PostgreSQL DB)
```bash
cd server/
docker-compose up
```
Then access on localhost:3000/api/v1/

### UI
```bash
cd ui
npm install
npm run dev
```
Then access on localhost:8080

### Client
Setup your JWT auth key environment variable 'DEPENDENSEE_API_KEY'.
