FROM ruby
MAINTAINER amackey01@qub.ac.uk
RUN apt-get update
# && apt-get install -y sqlite3 libsqlite3-dev libxml2-dev libxslt1-dev
RUN mkdir -p /dependensee
WORKDIR /dependensee
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install
COPY . ./
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "127.0.0.1"]