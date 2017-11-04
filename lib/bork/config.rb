module Bork
  # for now this just uses hardcoded defaults
  module Config
    class << self
      def[](key)
        defaults[key]
      end

      def defaults
        {
          timeout: 30*60,  # half an hour per file max
        }
      end
    end
  end
end
