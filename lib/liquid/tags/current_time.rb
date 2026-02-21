module Liquid
  module Tags
    class CurrentTime < Liquid::Tag
      def initialize(tag_name, time_format, tokens)
        super

        @format = time_format&.strip || :iso8601
      end

      def render(context)
        Time.zone.now.to_formatted_s(@format.to_sym)
      end
    end
  end
end
