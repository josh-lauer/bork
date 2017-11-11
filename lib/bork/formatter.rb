module Bork
  module Formatter
    def self.display_tests(*tests)
      tests.flatten.each do |test|
        puts Pathname.new(Config.scope).realpath.to_s.length+1..-1]
      end
    end
    alias_method :display_test, :display_tests
  end
end
