FROM arm64v8/ruby:2.6-buster
LABEL maintainer="Lazarus Lazaridis http://iridakos.com"

# Change to repo directory
WORKDIR /opt/duckrails

# From now on execute rails stuff in production mode
ENV RAILS_ENV production
ENV RACK_ENV production

# Expose container port 80
EXPOSE 80

# Add Required Packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs libpq-dev libxml2-dev default-libmysqlclient-dev libsqlite3-dev sqlite3\
    && rm -rf /var/lib/apt/lists/*

# Add docker entrypoint.sh
COPY docker-entrypoint.sh /

# Copy in Gemfile
COPY Gemfile Gemfile.lock ./

RUN gem install bundler:1.17.3

# Install Gems
RUN bundle install --deployment --without development test --binstubs --jobs=2 --retry=4

# Copy in the rest of the app
COPY . .

# Configure database & install gems
COPY config/database.yml.sample config/database.yml

# Compile the assets
RUN bundle exec rake assets:precompile

# Add entrypoint for running db:migrations on upgrades
# and setting a unique SECRET_KEY_BASE value if not already set
ENTRYPOINT ["/docker-entrypoint.sh"]

# Start the server
CMD ["puma"]
