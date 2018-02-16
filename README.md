[![Build Status](https://travis-ci.com/PercussiveElbow/Dependensee.svg?token=pvU3wgppiDA8vnEdogBq&branch=master)](https://travis-ci.com/PercussiveElbow/Dependensee)[![Open Source Love](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://github.com/ellerbrock/open-source-badge/)

Dependensee is an open source patch/vulnerability manager for third party dependencies used in software projects. 

It can keep track of libraries used in your Ruby/Java/Python projects and report any CVEs they are vulnerable to, providing links, CVE information, reports and PoC exploits where avaliable.

It consists of three parts:
- Rails server to store/manage your dependencies. Exposes a REST API
- *(Optional)* Ruby client to automatically scan projects.
- *(Optional)* WebUI powered by VueJS



### API Documentation
[in progress]

### Requirements
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

## Dev Setup 
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

### Sources
https://github.com/rubysec/ruby-advisory-db

https://github.com/victims/victims-cve-db

https://github.com/offensive-security/exploit-database

http://cve.mitre.org/data/refs/refmap/source-EXPLOIT-DB.html

### License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
