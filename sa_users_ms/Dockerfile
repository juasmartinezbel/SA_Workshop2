FROM ruby:2.3

RUN mkdir /sa_users_ms
WORKDIR /sa_users_ms

ADD Gemfile /sa_users_ms/Gemfile
ADD Gemfile.lock /sa_users_ms/Gemfile.lock

RUN bundle install
ADD . /sa_users_ms