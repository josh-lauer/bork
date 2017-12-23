require 'fileutils'
require 'forwardable'
require 'pathname'

module Bork
  # An attempt to run a collection of Tests.
  # - has a collection of Tests and Runners
  # - is searchable
  # - has a state and is resettable
  class Session
    attr_reader :descriptor, :scope

    def initialize(descriptor = 'default', scope = Dir.pwd)
      @descriptor = descriptor.to_s
      @scope = Pathname.new(File.expand_path(scope)).realpath.to_s
      create_folder
    end

    # class methods
    class << self
      extend Forwardable
      def_delegators :current, :root, :reset, :scope, :descriptor

      def current
        @current ||= self.new
      end

      # set the current session by name and scope
      def set(descriptor, scope)
        @current = self.new(descriptor, scope)
      end

      # list all session names
      def list
        Dir.glob(File.join(Config.sessions_root, '*')).map { |d| File.basename(d) }
      end

      # Delete a session by name. Switch to default session if the deleted
      #   session was the current session and now longer exists.
      def delete(session_name)
        # delete the session folder
        self.new(session_name).delete
        # if you just deleted the current session, join the default session
        @current = self.new if current.descriptor == session_name.to_s
      end
    end # class methods

    def tests
      @tests ||= loader.tests
    end

    def loader
      @loader ||= Loader.new(scope)
    end

    # the folder containing this session's logs
    def root
      File.join(Config.sessions_root, descriptor)
    end

    # empty the session folder, flush cached test objects
    def reset
      FileUtils.rm_rf(File.join(root, '*'))
      @tests = nil
    end

    # delete the session folder
    def delete
      FileUtils.rm_rf(root)
    end

    # create the session folder if necessary
    def create_folder
      unless Dir.exist?(root)
        FileUtils.mkdir_p(root)
      end
    end
  end
end
