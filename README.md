[![Build Status](https://travis-ci.com/PercussiveElbow/Dependensee.svg?token=pvU3wgppiDA8vnEdogBq&branch=master)](https://travis-ci.com/PercussiveElbow/Dependensee)

### Requirements
#### Server
- Ruby (2.4.0+ but earlier probably works)
- RubyGems
- Bundler
- Your own PostgreSQL DB (if not using docker-compose)
#### Frontend
- NodeJS
- NPM
#### Client
- Ruby (2.4.0+ but earlier probably works)

## Dev Setup 
### Server
```bash
cd server/
bundle install
rails db:setup
rails s
```
### Frontend
```javascript
npm install
npm run:dev
```
Then access on localhost:8080

