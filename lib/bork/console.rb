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
      @context = Context.new
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
        # REPL.start(binding)
        REPL.start(context.binding)
      end
    end

    # run the tests
    def run(arg = nil)
      # run the tests
      puts "running the tests!"
      tests = []
      @__bork_interrupt = false

      tests.each do |test|
        break if @__bork_interrupt
        test.run
      end

      puts "done running the tests!"
    end

    def help
      puts "some help text"
      puts "#{options.inspect}"
    end

    def session
      @session ||= Session.new('default', options.scope)
    end

    def tests
      session.tests
    end

    def list
      puts tests.map { |t| t.path[Pathname.new(options.scope).realpath.to_s.length+1..-1] }
    end
  end
end
