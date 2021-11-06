module Liquid
  module Tags
    class Sleep < Liquid::Tag
      def initialize(tag_name, seconds, tokens)
        super

        @seconds = seconds&.strip&.to_i || 1
      end

      def render(context)
        sleep @seconds
        nil
      end
    end
  end
end
