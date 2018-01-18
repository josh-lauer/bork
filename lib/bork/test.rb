require 'digest'
require 'fileutils'
require 'pathname'
require 'forwardable'

module Bork
  class Test
    include Metadata::Persistence
    attr_persister :disabled, root: :job_folder

    attr_reader :path, :rvm_context

    def initialize(path, rvm_context = nil)
      @path = Pathname.new(File.expand_path(path)).realpath.to_s
      @rvm_context = Pathname.new(File.expand_path(rvm_context)).realpath.to_s
    end

    # Run the test, generating artifacts in the job_folder, return Status
    def run
      if enabled?
        reset
        puts "Running test: #{path}"
        puts "Follow Here: #{File.join(job_folder, 'all.log')}"
        runner.run(command, job_folder)
        puts Formatter.status_line(self)
        status
      else
        puts "Test disabled, skipping."
      end
    end

    def runner
      @runner ||= Runner.new
    end

    # The shell command to run this test, whose output we want captured and parsed.
    def command
      # [*context_prefix, 'ruby', path, '--use-color=true'] # minitest blows up here
      [*context_prefix, 'ruby', path]
    end

    def context_prefix
      rvm_context ? ['rvm', 'in', rvm_context, 'do'] : []
    end

    # The test's status.
    def status
      @status ||= check_status
    end

    # Parse the artifacts in the job folder, return a Status, memoize result
    def check_status
      @status = parser.parse
    end

    # The folder containing all of the current job's artifacts
    def job_folder
      File.join(Session.current.root, job_key)
    end

    # A unique identifier for this particular test to be used for a job folder
    def job_key
      Digest::MD5.hexdigest(path)
    end

    # Reset the status and delete the job folder
    def reset
      @status = nil
      FileUtils.rm_rf(job_folder) if Dir.exist?(job_folder)
    end

    # The parser analyzes test artifacts to generate a Status
    def parser
      @parser ||= parser_klass.new(job_folder)
    end

    def all_log
      IO.readlines(File.join(job_folder, 'all.log'))
    end

    # @todo make this configurable
    def parser_klass
      Parser
    end

    def enabled?
      !disabled
    end

    def disabled?
      !!disabled
    end

    def disable
      self.disabled = true
    end

    def enable
      self.disabled = false
    end
  end
end
