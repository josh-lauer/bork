require 'irb'

module Bork
  # allow dropping into a REPL while avoiding using pry
  # pry has a major bug that makes it impossible to use in this context
  # (basically threading within a Timeout block blows up)
  module REPL
    def self.start(binding)
      unless @__initialized
        args = ARGV
        ARGV.replace(ARGV.dup)
        IRB.setup(nil)
        ARGV.replace(args)
        @__initialized = true
      end

      IRB.module_eval do
        workspace = IRB::WorkSpace.new(binding)
        irb = IRB::Irb.new(workspace)
        @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
        @CONF[:MAIN_CONTEXT] = irb.context

        catch(:IRB_EXIT) do
          irb.eval_input
        end
      end
    end
  end
end
