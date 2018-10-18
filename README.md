[![Build Status](https://api.travis-ci.org/PercussiveElbow/Dependensee.svg?branch=master)](https://travis-ci.org/PercussiveElbow/Dependensee/)<a href="https://codeclimate.com/github/PercussiveElbow/Dependensee/test_coverage"><img src="https://api.codeclimate.com/v1/badges/9a064cca8a09e6e40b1f/test_coverage" /></a><a href="https://codeclimate.com/github/PercussiveElbow/Dependensee/maintainability"><img src="https://api.codeclimate.com/v1/badges/9a064cca8a09e6e40b1f/maintainability" /></a>[![](https://images.microbadger.com/badges/image/percussiveelbow/dependensee.svg)](https://microbadger.com/images/percussiveelbow/dependensee "Get your own image badge on microbadger.com")[![Open Source Love](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://github.com/ellerbrock/open-source-badge/)
 

Dependensee is an open source patch/vulnerability manager for third party libraries

It can keep track of libraries used in your projects and will report any CVEs those libraries are vulnerable to, providing links, CVE information, reports and PoC exploits where avaliable.

Dependency files can be uploaded by either the API, or by using the UI.

Current language support:
<a href="https://img.shields.io/badge/language-ruby-red.svg"><img src="https://img.shields.io/badge/language-ruby-red.svg"/></a>
<a href="https://img.shields.io/badge/language-java-blue.svg"><img src="https://img.shields.io/badge/language-java-blue.svg"/></a>
<a href="https://img.shields.io/badge/language-python-green.svg"><img src="https://img.shields.io/badge/language-python-green.svg"/></a>

It consists of three parts:
- Rails server to store and manage your dependencies. This exposes a REST API
- *(Optional)* Ruby client to automatically scan projects on disk.
- *(Optional)* UI powered by VueJS

## Demo (Demo site disabled now)
~~https://dependensee.tech~~

## Demo Videos
https://gfycat.com/terrificweechameleon

https://gfycat.com/LeadingCelebratedFlyingfox

https://gfycat.com/HappyNauticalGenet

## Run it yourself (Requires Docker+Docker Compose)
Download latest <a href="https://github.com/PercussiveElbow/Dependensee/releases" >release</a> and export a RAILS_SECRET to your shell (must contain both letters and numbers). Then run:
```bash
docker-compose -f dependensee_release.yml up
```
The API can then be hit on localhost:3000, or alternatively the UI can be accessed on localhost:80

## Development Setup
<a href="https://github.com/PercussiveElbow/Dependensee/blob/master/DEVSETUP.md"> Development Setup can be found here </a>

## API Documentation
https://dependensee.tech/docs

Or when you're running the server locally simply hit localhost:3000/docs

## Sources
https://github.com/rubysec/ruby-advisory-db

https://github.com/victims/victims-cve-db

https://github.com/offensive-security/exploit-database

http://cve.mitre.org/data/refs/refmap/source-EXPLOIT-DB.html

## License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
