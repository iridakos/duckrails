module Duckrails
  class Router
    METHODS = [:get, :post, :put, :patch, :delete, :options, :head].freeze

    REGISTERED_MOCKS = []

    class << self
      def register_mock(mock)
        REGISTERED_MOCKS << mock.id
        REGISTERED_MOCKS.uniq!
      end

      def register_current_mocks
        REGISTERED_MOCKS << Duckrails::Mock.pluck(:id)
        REGISTERED_MOCKS.flatten!
        REGISTERED_MOCKS.uniq!
      end

      def unregister_mock(mock)
        REGISTERED_MOCKS.delete mock.id
      end

      def reset!
        REGISTERED_MOCKS.clear
        register_current_mocks
        reload_routes!
      end

      def load_mock_routes!
        mocks =  REGISTERED_MOCKS.map do |mock_id|
          Duckrails::Mock.find mock_id
        end

        mocks = mocks.sort_by{ |mock| mock.mock_order }

        mocks.each do |mock|
          define_route mock
        end
      end

      def reload_routes!
        Duckrails::Application.routes_reloader.reload!
      end

      protected

      def define_route(mock)
        return unless mock.active?

        Duckrails::Application.routes.draw do
          self.send(:match, mock.route_path, to: 'duckrails/mocks#serve_mock', defaults: { duckrails_mock_id: mock.id }, via: mock.request_method)
        end
      end
    end
  end
end
