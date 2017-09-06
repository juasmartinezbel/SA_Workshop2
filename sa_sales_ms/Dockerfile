FROM ruby:2.3

RUN mkdir /sa_sales_ms
WORKDIR /sa_sales_ms

ADD Gemfile /sa_sales_ms/Gemfile
ADD Gemfile.lock /sa_sales_ms/Gemfile.lock

RUN bundle install
ADD . /sa_sales_ms