FROM ruby:2.6.4

# Install system dependencies
RUN apt-get update \
 && apt-get install -y apt-transport-https ca-certificates \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y nodejs yarn postgresql-client

# Create project directory (workdir)
RUN mkdir /app
WORKDIR /app

# Copy Gemfile and Gemfile.lock to WORKDIR
COPY Gemfile .
COPY Gemfile.lock .

# Install dependencies
RUN bundle install && yarn install --check-files

# Copy remaining source code files to WORKDIR
COPY . .

EXPOSE 3000

# Start rails server
ENTRYPOINT ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
 