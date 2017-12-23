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

    # run the tests, by default all of them
    def run(arg = nil)
      selected_tests = resolve_tests(arg)
      puts "RUNNING TESTS:"
      list(selected_tests)

      @__bork_interrupt = false

      # allows the use of ctrl-c to bail out of a test to
      Signal.trap('SIGINT') { @__bork_interrupt = true }

      selected_tests.each do |test|
        break if @__bork_interrupt
        test.run
      end

      puts "done running the tests!"
    end
    alias_method :r, :run

    def verbose!
      Config[:echo] = true
    end

    def quiet!
      Config[:echo] = false
    end

    # # show the output of selected tests, or all output from all tests by default
    # def show(arg = nil)
    #   selected_tests = resolve_tests(arg)
    #   selected_tests.map(&:output).each { |line| puts line }
    #   nil
    # end
    # alias_method :s, :show

    def help
      puts "some help text"
      puts "#{options.inspect}"
    end

    def session
      @session ||= Session.set(options.session || 'default', options.scope)
    end

    def tests
      session.tests
    end

    def list(arg = nil)
      @last_list = resolve_tests(arg)
      Formatter.display_tests(@last_list)
    end
    alias_method :l, :list

    def resolve_tests(arg)
      case arg
      when Fixnum, Range
        [*@last_list[arg]].compact rescue( puts "Error! No list cached."; [] )
      when nil
        select_tests # list all the tests
      when Array
        arg # it's already an array of tests
      when Symbol, String, Regexp
        select_tests(Regexp.new(arg.to_s))
      else
        []
      end
    end

    # - if no argument is passed, return all tests
    # - if a String, Symbol, or Regexp is passed, select tests by file_path
    def select_tests(regex = nil)
      regex && tests.select{|t| t.path =~ Regexp.new(regex.to_s)} || tests
    end

    # those tests which have not yet been run
    def unattempted(selected_tests = select_tests)
      selected_tests.select(&:unattempted?)
    end

    # those tests which have been attempted to run, regardless of outcome
    def attempted(selected_tests = select_tests)
      selected_tests.select(&:attempted?)
    end

    # those tests which have been attempted but didn't finish
    def incomplete(selected_tests = select_tests)
      selected_tests.select(&:crashed?)
    end
    alias_method :crashed, :incomplete

    # those tests which have been run and did pass
    def passing(selected_tests = select_tests)
      selected_tests.select(&:passing?)
    end

    # those tests which have been run
    def completed(selected_tests = select_tests)
      selected_tests.select(&:completed?)
    end

    # those tests which have been completed and did not pass
    def failing(selected_tests = select_tests)
      selected_tests.select(&:failing?)
    end

    # those tests which have been run and had errors
    def errors(selected_tests = select_tests)
      selected_tests.select(&:has_errors?)
    end
  end
end
