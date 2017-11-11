require 'ostruct'
require 'pathname'

module Bork
  class Console
    attr_reader :options, :context

    # @option options [String] scope (Dir.pwd) The folder which will serve as
    #   the 'root' for this console session. Only tests within this directory
    #   will be tracked and run.
    def initialize(_options = {})
      @options = OpenStruct.new(_options)
      @context = Context.new(@options)
      puts "Bork::Console OPTIONS: #{options.inspect}"
    end

    def start
      if @__session_started
        puts "Session already started."
      else
        @__session_started = true

        # allows the use of ctrl-c to bail out of a test to
        puts "Trapping SIGINT..."
        Signal.trap('SIGINT') { @__bork_interrupt = true }

        puts "Starting session..."
        puts "Hint: call 'help'"
        REPL.start(context.get_binding)
      end
    end
  end
end
