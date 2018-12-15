FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RAILS_ROOT /var/www/scheduler
ARG environment

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV=${environment}
ENV RACK_ENV=${environment}

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN if ["$environment" = "production"]; then  \
        bundle install --jobs 20 --retry 5 --without development test; \
    else \
        bundle install --path vendor/bundle; \
fi

# Adding project files
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
