require "bork/version"

module Bork
  # Bork's settings.
  autoload :Config, 'bork/config'

  # Represents a single test file.
  # - has a Runner
  autoload :Test, 'bork/test'

  # An attempt to run a collection of Tests.
  # - has a collection of Tests
  # - is searchable
  autoload :Session, 'bork/session'

  # Finds test files and builds a Session.
  # - builds a Session
  autoload :Loader, 'bork/loader'

  # A Test's output. Like a logger, sort of.
  autoload :Log, 'bork/log'

  # Parses a Log and returns a Status. For now just parses Test:::Unit output.
  # - consumes a Log to produce a Status
  autoload :Parser, 'bork/parser'

  # A Test's result. Has a state such as 'passing', 'failing', or 'errored'.
  autoload :Status, 'bork/status'

  # Takes a Test and runs it, creating a Log and a Status.
  # - has a Log.
  # - has a Status.
  autoload :Runner, 'bork/runner'

  # Creates an interactive session.
  # - instantiates a Session
  # - starts a REPL
  autoload :Console, 'bork/console'

  # used as a pry replacement
  autoload :REPL, 'bork/repl'
end
