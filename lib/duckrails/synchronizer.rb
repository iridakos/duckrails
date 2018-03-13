module Duckrails
  class Synchronizer
    def initialize(app)
      @app = app
    end

    def call(env)
      timestamp = Rails.cache.read(:routes_changed_timestamp)
      if Thread.current[:routes_changed_timestamp] != timestamp
        Rails.logger.info 'Mock synchronization token missmatch. Syncronizing...'
        Router.reset!
        Thread.current[:routes_changed_timestamp] = timestamp
        Rails.logger.info 'Mock synchronization completed.'
      end

      @status, @headers, @response = @app.call(env)

      [@status, @headers, @response]
    end

    class << self
      def generate_token
        SecureRandom.uuid
      end
    end
  end
end
