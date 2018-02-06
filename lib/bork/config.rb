require 'ostruct'

module Bork
  # for now this just uses hardcoded defaults
  module Config
    class << self
      # the folder containing all of this user's bork sessions, config, test
      #   output, metadata, etc. This creates it if it doesn't already exist.
      def bork_root
        @bork_root ||= File.join(Dir.home, '.bork').tap do |root|
          unless Dir.exist?(root)
            FileUtils.mkdir_p(root)
            FileUtils.mkdir_p(sessions_root)
          end
        end
      end

      # the folder containing all of this user's bork sessions and config
      #   creates it if it doesn't already exist
      def sessions_root
        File.join(bork_root, 'sessions')
      end

      def [](key)
        options[key]
      end

      def []=(key, value)
        options[key] = value
      end

      def delete(key)
        options.delete_field(key)
      end

      def options
        @options ||= OpenStruct.new(defaults)
      end

      # @param opts [Hash] the options to be merged into the config
      #
      # @return [OpenStruct] the new options object with merge applied
      def merge(opts)
        OpenStruct.new(to_h.merge(opts))
      end

      # @param opts [Hash] the options to be merged into the config
      #
      # @return [OpenStruct] the new options object with merge applied
      def merge!(opts)
        @options = merge(opts)
      end

      def defaults
        {
          timeout: 30*60,     # half an hour per file max
          echo: false,        # test output displayed
          context: Dir.pwd,   # wherever bork was initially run
          session: 'default',
        }
      end

      def to_h
        options.to_h
      end

      def reset
        @options = nil
      end

      # save options inside the session
      def save

      end

      # save options from the session
      def load

      end
    end
  end
end
