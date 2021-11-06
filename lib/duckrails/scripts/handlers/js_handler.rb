module Duckrails
  module Scripts
    module Handlers
      class JsHandler < Base
        def initialize
          super(:js)
        end

        def process(script, binding)
          headers = binding.eval('request').headers.select do |header|
            header[1].is_a? String
          end

          params = binding.eval('params')

          context =
            ExecJS.compile(
              "parameters = #{params.to_json}; headers = #{Hash[headers].to_json};"
            )

          context.exec script
        end
      end
    end
  end
end
