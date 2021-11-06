module Duckrails
  class Configuration
    class << self
      attr_reader :settings

      def load!
        @settings =
          YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'duckrails.yml'))).result)[Rails.env].
           deep_symbolize_keys.
           freeze
      end
    end

    load!
  end
end
