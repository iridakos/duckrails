require 'duckrails/router'

# Don't register mocks if there are pending migrations
if ActiveRecord::Base.connection.migration_context.needs_migration?
  puts 'Skipping registration of mocks due to pending migrations.'
else
  Duckrails::Router.register_current_mocks
end
