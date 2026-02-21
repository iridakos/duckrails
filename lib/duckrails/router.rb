require 'route_validator'
require 'duckrails/mock'

module Duckrails
  class Router
    METHODS = [:get, :post, :put, :patch, :delete, :options, :head].freeze

    @registered_mocks = []

    class << self
      attr_reader :registered_mocks

      def register_mock(mock)
        @registered_mocks << mock.id
        Duckrails::ApplicationState.instance.update_token :mock
        @registered_mocks.uniq!
      end

      def register_current_mocks
        @registered_mocks << Duckrails::Mock.pluck(:id)
        @registered_mocks.flatten!
        @registered_mocks.uniq!
      end

      def unregister_mock(mock)
        @registered_mocks.delete mock.id
        Duckrails::ApplicationState.instance.update_token :mock
      end

      def reset!
        @registered_mocks.clear
        register_current_mocks
        reload_routes!
      end

      def load_mock_routes!
        mocks =  @registered_mocks.map do |mock_id|
          Duckrails::Mock.find mock_id
        end

        mocks = mocks.sort_by{ |mock| mock.mock_order }

        mocks.each do |mock|
          define_route mock
        end
      end

      def clear_routes!(reload: false)
        @registered_mocks = []

        reload_routes! if reload
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
