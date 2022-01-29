FROM ruby:2.7.4-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    sqlite-dev \
    git \
    file \
    imagemagick \
    nodejs-current \
    yarn \
    tzdata

# Create project directory (workdir)
WORKDIR /app

# Install gems
COPY Gemfile* ./
# RUN bundle config --global frozen 1
RUN bundle install -j4 --retry 3

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
