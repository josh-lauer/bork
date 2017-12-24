require 'yaml'

module Bork
  module Metadata
    class Store
      attr_reader :job_folder

      def initialize(job_folder)
        @job_folder = job_folder
      end

      def [](k)
        store[k]
      end

      def []=(k,v)
        store[k] = v
        save
        v
      end

      def load
        if File.exist?(metadata_file)
          @metadata_store = YAML.load_file(metadata_file)
        end
      end

      def save
        # don't create a file if there's no metadata
        if store.any?
          # make the job dir if it doesn't exist, then save metadata file
          FileUtils.mkdir_p(job_folder) unless Dir.exist?(job_folder)
          File.write(metadata_file, store.to_yaml)
        end
      end

      private

      def metadata_file
        File.join(job_folder, 'metadata.yml')
      end

      def store
        @metadata_store ||= load || {}
      end
    end
  end
end
