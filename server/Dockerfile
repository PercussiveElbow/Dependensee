FROM ruby
MAINTAINER amackey01@qub.ac.uk
RUN apt-get update
RUN mkdir -p /dependensee
WORKDIR /dependensee
COPY Gemfile Gemfile.lock ./
COPY .gemrc ~/.gemrc
RUN gem install rubygems-update
RUN update_rubygems
RUN gem update --system
RUN gem install bundler && bundle install --jobs 4
COPY . ./
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "127.0.0.1"]