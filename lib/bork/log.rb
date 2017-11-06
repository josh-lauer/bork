module Bork
  class Log
    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
    end

    def <<(line)

    end
  end
end
