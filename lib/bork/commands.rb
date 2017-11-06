module Bork
  module Commands
    class << self
      def command_binding
        binding
      end

      def foo
        "foo!"
      end
    end
  end
end
