FROM ruby:2.6.4

# Install system dependencies
RUN apt-get update \
 && apt-get install -y apt-transport-https ca-certificates \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y nodejs yarn postgresql-client

RUN mkdir /app
WORKDIR /app

# Copy Gemfile and Gemfile.lock to WORKDIR
COPY Gemfile .
COPY Gemfile.lock .

# Install dependencies
RUN bundle install

# Copy remaining source code files to WORKDIR
COPY . .

EXPOSE 3000

# Start rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
