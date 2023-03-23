# Use a Ruby base image
FROM ruby:3.1.3-alpine

# Set the working directory
WORKDIR /app

# Install required packages
RUN apk add --update --no-cache \
  build-base \
  postgresql-dev \
  nodejs \
  yarn \
  tzdata

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without development test

# Copy the rest of the application code to the container
COPY . .

# Set the environment variables for the database
ENV DATABASE_URL=postgresql://postgres:password@db:5432/myapp_production
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Precompile assets
RUN bundle exec rails assets:precompile

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
