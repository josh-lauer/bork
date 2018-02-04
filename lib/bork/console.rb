require 'ostruct'
require 'pathname'

module Bork
  class Console
    attr_reader :options, :context

    # @option options [String] scope (Dir.pwd) The folder which will serve as
    #   the 'root' for this console session. Only tests within this directory
    #   will be tracked and run.
    def initialize(_options = {})
      @options = OpenStruct.new(Config.options.merge(_options))
      @context = Context.new(@options)
      puts "Bork::Console OPTIONS: #{options.inspect}"
    end

    def start
      if @__session_started
        puts "Session already started."
      else
        @__session_started = true

        puts "Starting bork session with options #{options.inspect}"
        puts "Hint: call 'help'"
        REPL.start(context.get_binding)
      end
    end
  end
end
