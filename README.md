[![Build Status](https://travis-ci.com/PercussiveElbow/Dependensee.svg?token=pvU3wgppiDA8vnEdogBq&branch=master)](https://travis-ci.com/PercussiveElbow/Dependensee)<a href="https://codeclimate.com/repos/5aa7e0eca785aa028600a9a2/test_coverage"><img src="https://api.codeclimate.com/v1/badges/6bbd1f9404a076d9834f/test_coverage" /></a><a href="https://codeclimate.com/repos/5aa7e0eca785aa028600a9a2/maintainability"><img src="https://api.codeclimate.com/v1/badges/6bbd1f9404a076d9834f/maintainability" /></a>[![Open Source Love](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://github.com/ellerbrock/open-source-badge/)


Dependensee is an open source patch/vulnerability manager for third party libraries

It keeps track of libraries used in your projects and reports any CVEs they are vulnerable to, providing links, CVE information, reports and PoC exploits where avaliable.

Current language support:
<a href="https://img.shields.io/badge/language-ruby-red.svg"><img src="https://img.shields.io/badge/language-ruby-red.svg"/></a>
<a href="https://img.shields.io/badge/language-java-blue.svg"><img src="https://img.shields.io/badge/language-java-blue.svg"/></a>
<a href="https://img.shields.io/badge/language-python-green.svg"><img src="https://img.shields.io/badge/language-python-green.svg"/></a>

It consists of three parts:
- Rails server to store/manage your dependencies. This exposes a REST API
- *(Optional)* Ruby client to automatically scan projects.
- *(Optional)* UI powered by VueJS

## Demo
https://dependensee.tech

## Run it yourself (Requires Docker+Docker Compose)
```bash
cd server/
./start.sh
```

## API Documentation
https://dependensee.tech/doc

Or when you're running the server simply hit localhost:3000/doc

## Sources
https://github.com/rubysec/ruby-advisory-db

https://github.com/victims/victims-cve-db

https://github.com/offensive-security/exploit-database

http://cve.mitre.org/data/refs/refmap/source-EXPLOIT-DB.html

## License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
