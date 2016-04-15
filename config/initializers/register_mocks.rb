require 'duckrails/router'

begin
  # Don't register mocks if there are pending migrations
  Duckrails::Router.register_current_mocks if ActiveRecord::Base.connection.table_exists? Duckrails::Mock.table_name

rescue ActiveRecord::NoDatabaseError => e
rescue Mysql2::Error => e
  Rails.logger.info "Skipping mock route registration, no database."
  Rails.logger.debug e.message
  Rails.logger.debug e.backtrace
end
