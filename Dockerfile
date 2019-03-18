FROM ruby

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

# Copy gemfile into container
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy application into container
COPY . .

EXPOSE 8888

# Run application
CMD ["ruby", "app.rb"]
