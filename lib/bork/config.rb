require 'ostruct'

module Bork
  # for now this just uses hardcoded defaults
  module Config
    class << self
      # the folder containing all of this user's bork sessions and config
      #   creates it if it doesn't already exist
      def bork_root
        @bork_root ||= File.join(Dir.home, '.bork').tap do |root|
          unless Dir.exist?(root)
            FileUtils.mkdir_p(root)
            FileUtils.mkdir_p(sessions_root)
          end
        end
      end

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

      def defaults
        {
          timeout: 30*60,     # half an hour per file max
          echo: false,        # test output displayed
          context: Dir.pwd,   # wherever bork was initially run
          session: 'default',
        }
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
