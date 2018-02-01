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
        if v
          store[k] = v
        else
          store.delete(k)
        end
        save
      end

      # @return [Hash, nil] hash if metadata is persisted, else nil
      def load
        if File.exist?(metadata_file)
          @metadata_store = YAML.load_file(metadata_file)
        end
      end

      def save
        # if there's metadata, save the file
        if store.select { |_,v| v }.any?
          # make the job dir if it doesn't exist, then save metadata file
          FileUtils.mkdir_p(job_folder) unless Dir.exist?(job_folder)
          File.write(metadata_file, store.select { |_,v| v }.to_yaml)
        else
          # if the store is empty, delete the metadata file if one exists
          File.delete(metadata_file) if File.exist?(metadata_file)
        end
      end

      private

      def metadata_file
        File.join(job_folder, 'metadata.yml')
      end

      # loads metadata or initializes new empty store
      def store
        @metadata_store ||= load || {}
      end
    end
  end
end
