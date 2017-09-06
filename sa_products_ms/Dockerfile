FROM ruby:2.3

RUN mkdir /sa_products_ms
WORKDIR /sa_products_ms

ADD Gemfile /sa_products_ms/Gemfile
ADD Gemfile.lock /sa_products_ms/Gemfile.lock

RUN bundle install
ADD . /sa_products_ms