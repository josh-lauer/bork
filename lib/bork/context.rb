require 'ostruct'

module Bork
  # Every bork console session uses this. These are the methods available in the shell.
  class Context
    attr_reader :options

    def initialize(options)
      @options = options
    end

    # Used by Console to start
    def get_binding
      binding
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
      Formatter.display_tests(tests)
    end
    alias_method :l, :list
  end
end
