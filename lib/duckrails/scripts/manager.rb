module Duckrails
  module Scripts
    class Manager
      SCRIPT_HANDLERS = {
        Duckrails::Scripts::SCRIPT_TYPE_EMBEDDED_RUBY => Duckrails::Scripts::Handlers::EmbeddedRubyHandler.new,
        Duckrails::Scripts::SCRIPT_TYPE_JS => Duckrails::Scripts::Handlers::JsHandler.new,
        Duckrails::Scripts::SCRIPT_TYPE_STATIC => Duckrails::Scripts::Handlers::StaticHandler.new,
        Duckrails::Scripts::SCRIPT_TYPE_LIQUID => Duckrails::Scripts::Handlers::LiquidHandler.new
      }.with_indifferent_access.freeze

      def self.for(script_type)
        handler = SCRIPT_HANDLERS[script_type]

        raise ArgumentError, "Can't resolve handler for script type: #{script_type}" unless handler

        handler
      end
    end
  end
end
