FROM ruby:2.3.0-slim

ENV RAILS_ENV production
ENV SECRET_KEY_BASE $(openssl rand -base64 32)

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /myapp
ONBUILD ADD Gemfile /myapp
ONBUILD ADD Gemfile.lock /myapp
ONBUILD RUN bundle install --without test development --path vendor/bundle -j4

COPY . /myapp
RUN bundle exec rake assets:precompile

CMD ["script/server"]
