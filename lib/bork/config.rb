module Bork
  # for now this just uses hardcoded defaults
  module Config
    class << self
      # the folder containing all of this user's bork sessions and config
      #   creates it if it doesn't already exist
      def bork_root
        @session_root ||= File.join(Dir.home, '.bork').tap do |root|
          unless Dir.exist?(root)
            FileUtils.mkdir_p(root)
            FileUtils.mkdir_p(sessions_root)
          end
        end
      end

      def sessions_root
        File.join(bork_root, 'sessions')
      end

      def[](key)
        defaults[key]
      end

      def defaults
        {
          timeout: 30*60,  # half an hour per file max
          echo: false      # test output displayed
        }
      end
    end
  end
end
