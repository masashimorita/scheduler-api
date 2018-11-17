FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV APP_HOME /scheduler

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
ADD . $APP_HOME
