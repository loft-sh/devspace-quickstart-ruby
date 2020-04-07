FROM ruby:2.6.4-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    file \
    imagemagick \
    nodejs-current \
    yarn \
    tzdata

# Create project directory (workdir)
RUN mkdir /app
WORKDIR /app

# Install gems
ADD Gemfile* .
RUN bundle config --global frozen 1 \
 && bundle install test -j4 --retry 3

# Install yarn packages
COPY package.json yarn.lock ./
RUN yarn install

# Add source code files to WORKDIR
COPY . .

# Application port (optional)
EXPOSE 3000

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=foo bundle exec rake assets:precompile

# Container start command
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
