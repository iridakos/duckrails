module Liquid
  module Tags
    class CurrentDate < Liquid::Tag
      def initialize(tag_name, date_format, tokens)
        super

        @format = date_format&.strip || :iso8601
      end

      def render(context)
        Date.today.to_formatted_s(@format.to_sym)
      end
    end
  end
end
