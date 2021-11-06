module Duckrails
  module Scripts
    module Handlers
      class StaticHandler < Base
        def initialize
          super(:static)
        end

        def process(script, _)
          script
        end
      end
    end
  end
end
