module Bork
  # Every bork console session uses this. These are the methods available in the shell.
  module Context
    def binding
      binding
    end

    def foo
      "foo!"
    end
  end
end
