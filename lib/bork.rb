require "bork/version"

module Bork
  # Bork's settings.
  autoload :Config, 'bork/config'

  # Represents a single test file.
  # - has a Runner
  # - has a Status.
  autoload :Test, 'bork/test'

  # An attempt to run a collection of Tests.
  # - has a collection of Tests
  # - is searchable
  autoload :Session, 'bork/session'

  # Finds test files and builds a Session.
  # - builds a Session
  autoload :Loader, 'bork/loader'

  # # A Test's output. Like a logger, sort of. (not sure if needed)
  # autoload :Log, 'bork/log'

  # Parses a Log and returns a Status. For now just parses Test:::Unit output.
  # - consumes a Log to produce a Status
  autoload :Parser, 'bork/parser'

  # A Test's result. Has a state such as 'passing', 'failing', or 'errored'.
  autoload :Status, 'bork/status'

  # Takes a Test and runs it, creating artifacts in the job folder for this test.
  autoload :Runner, 'bork/runner'

  # Creates an interactive session.
  # - instantiates a Session
  # - starts a REPL
  autoload :Console, 'bork/console'

  # used as a pry replacement - pry has some issues with the Timeout class
  autoload :REPL, 'bork/repl'

  # Contains commands accessible in the bork shell, serves as an execution
  #   context, the "self" of a console session.
  autoload :Context, 'bork/context'

  # produces display text given a test
  autoload :Formatter, 'bork/formatter'

  # stored information about particular tests
  autoload :Metadata, 'bork/metadata'

  autoload :Log, 'bork/log'
end
