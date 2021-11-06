module Duckrails
  module Scripts
    extend self

    SCRIPT_TYPE_EMBEDDED_RUBY = 'embedded_ruby'.freeze
    SCRIPT_TYPE_LIQUID = 'liquid'.freeze
    SCRIPT_TYPE_STATIC = 'static'.freeze
    SCRIPT_TYPE_JS = 'js'.freeze

    def enabled_script_types
      @enabled_script_types ||=
        Duckrails::Scripts::Manager::SCRIPT_HANDLERS.
        select do |_, handler|
          handler.enabled?
        end.
        keys
    end
  end
end
