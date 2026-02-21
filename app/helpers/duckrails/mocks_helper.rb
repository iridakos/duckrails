module Duckrails
  module MocksHelper
    def available_mime_types
      Mime::EXTENSION_LOOKUP.map{ |a| a[1].to_s }.uniq.sort
    end

    def available_script_types
      Duckrails::Scripts.enabled_script_types.map do |key|
        [t(key), key]
      end
    end
  end
end
