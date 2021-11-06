module Duckrails
  module Scripts
    module Handlers
      class EmbeddedRubyHandler < Base
        def initialize
          super(:embedded_ruby)
        end

        def process(script, binding)
          ERB.new(script).result(binding)
        end
      end
    end
  end
end
