require 'liquid/tags/sleep'
require 'liquid/tags/current_time'
require 'liquid/tags/current_date'

module Liquid::Tags
  Liquid::Template.register_tag('sleep', Liquid::Tags::Sleep)
  Liquid::Template.register_tag('current_time', Liquid::Tags::CurrentTime)
  Liquid::Template.register_tag('current_date', Liquid::Tags::CurrentDate)
end
