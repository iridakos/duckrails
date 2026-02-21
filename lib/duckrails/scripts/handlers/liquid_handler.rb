module Duckrails
  module Scripts
    module Handlers
      class LiquidHandler < Base
        def initialize
          super(:liquid)
        end

        def process(script, binding)
          headers = binding.eval('headers')
          params = binding.eval('params')

          context_variables = {
            headers: Hash[headers.select{ |header| header[1].is_a? String }],
            parameters: params
          }

          embedded_script = Liquid::Template.parse(script)

          embedded_script.render(context_variables.as_json)
        end
      end
    end
  end
end
