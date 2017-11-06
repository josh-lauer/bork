require "pathname"

module Bork
  class Loader
    attr_accessor :targets, :test_files

    def initialize(*_targets)
      self.targets = [*_targets].flatten.compact
      self.targets << Dir.pwd if targets.empty?
      reload!
    end

    def reload!
      puts "LOADING TARGETS: #{targets}"
      @test_files = []
      @tests = nil
      @rvm_contexts = nil
      @tests_with_context = nil
      load_test_files
    end

    # private

    def load_test_files
      targets.each do |target|
        puts "LOADING TARGET: #{target.inspect}"
        load_file_or_directory(target)
      end
    end

    # # a "target" is a test file or directory containing test files
    # def load_target(target)
    #   if Dir.exist?(target)
    #     puts "LOADING DIRECTORY: #{target.inspect}"
    #     glob_pattern = File.join(target, "**", "*_test.rb")
    #     matches = Dir.glob(glob_pattern)
    #     tests_to_load = matches.select { |test| load_test?(test) }
    #     self.test_files += tests_to_load.map do |test|
    #       File.realdirpath(test)
    #     end
    #   elsif File.exist?(target) && !Dir.exist?(target) && load_test?(target)
    #     puts "LOADING FILE: #{target.inspect}"
    #     # add a single test if it is not already loaded
    #     test_files |= [ File.realdirpath(target) ]
    #   else
    #     raise "File or dir not found #{target.inspect}"
    #   end
    # end

    def load_file_or_directory(target)
      puts "LOADING FILE OR DIRECTORY: #{target.inspect}"
      load_directory(target) || load_file(target) || (raise "File or dir not found #{target.inspect}")
    end

    # returns falsy only if it can't be loaded
    def load_file(target)
      if File.exist?(target) && !Dir.exist?(target) && load_test?(target)
        puts "LOADING FILE: #{target.inspect}"
        # add a single test if it is not already loaded
        test_files |= [ File.realdirpath(target) ]
      end
    end

    # add all the tests in the target dir
    # returns falsy only if it can't be added
    def load_directory(target)
      if Dir.exist?(target)
        puts "LOADING DIRECTORY: #{target.inspect}"
        glob_pattern = File.join(target, "**", "*_test.rb")
        matches = Dir.glob(glob_pattern)
        tests_to_load = matches.select { |test| load_test?(test) }
        self.test_files += tests_to_load.map do |test|
          File.realdirpath(test)
        end
      end
    end

    # # find all tests within pwd, intialize Unit objects
    # def build_units
    #   tests_with_context.each_pair do |filename, context|
    #     self.units << Unit.new(filename, rvm_context: context, timeout: options.timeout)
    #   end
    # end

    # find all tests within pwd, intialize Unit objects
    def tests
      @tests ||= tests_with_context.map do |filename, context|
        Test.new(filename, context)
      end
    end

    # #
    # def contexts_with_tests
    #   @contexts_with_tests ||= {}.tap do |hsh|
    #     rvm_contexts.each do |context|
    #       hsh[context] = test_files.select { |filename| filename.include?(context) }
    #     end
    #   end
    # end

    #
    def tests_with_context
      @tests_with_context ||= {}.tap do |hsh|
        test_files.each do |test|
          hsh[test] = rvm_contexts.detect { |context| test.include?(context) }
        end
      end
    end

    # returns true if a given test should be loaded
    def load_test?(test)
      # jruby copies gems into a target directory, this makes sure it doesn't read them
      !Pathname(test).each_filename.to_a.include?('target')
    end

    #
    def rvm_contexts
      @rvm_contexts ||= begin
        rvm_paths = File.join("**", ".ruby-version")
        files = Dir.glob(rvm_paths).map{|p| File.realdirpath(p).sub('.ruby-version', '')}
        files.sort{|a,b| b.length <=> a.length }
      end
    end

  end
end
