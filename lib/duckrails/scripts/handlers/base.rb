module Duckrails
  module Scripts
    module Handlers
      class DisabledScriptTypeError < StandardError
        def initialize(script_type)
          @script_type = script_type
        end

        def message
          "Evaluation of #{@script_type.to_s.humanize} scripts is disabled."
        end
      end

      class Base
        attr_reader :script_type

        def initialize(script_type)
          @script_type = script_type
        end

        def evaluate(script, binding, force_json: false)
          raise DisabledScriptTypeError, @script_type unless enabled?

          result = process(script, binding) unless script.blank?

          if force_json
            result ||= '{}'
            JSON.parse(result)
          else
            result
          end
        end

        def process(script, binding)
          raise NotImplementedError
        end

        def enabled?
          Duckrails::Configuration.settings.dig(:handlers, @script_type, :enabled)
        end
      end
    end
  end
end
