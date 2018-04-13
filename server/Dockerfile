FROM ruby:alpine
MAINTAINER amackey01@qub.ac.uk
RUN apk add --update \
  build-base \
  tzdata \
  postgresql-dev \
  git \
  bash \
  && rm -rf /var/cache/apk/*
RUN mkdir -p /dependensee
WORKDIR /dependensee
COPY Gemfile Gemfile.lock ./
COPY .gemrc ~/.gemrc
RUN gem install rubygems-update && update_rubygems && gem update --system && gem install bundler
RUN bundle install --jobs 4
COPY . ./
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "127.0.0.1"]