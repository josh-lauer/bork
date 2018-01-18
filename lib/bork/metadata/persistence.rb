module Bork
  module Metadata
    module Persistence
      class << self
        def included(klass)
          klass.extend ClassMethods
        end

        def extended(*)
          raise "Include #{self.class}, do not extend it."
        end
      end

      def store
        @store = Store.new(metadata_store_root)
      end

      def persistent_attributes
        self.class.persistent_attributes
      end

      def metadata_store_root
        root_method = self.class.metadata_store_root
        if respond_to?(root_method)
          send(root_method)
        else
          raise "No #{root_method.inspect} method exists on #{self.class}, cannot find metadata store root."
        end
      end

      module ClassMethods
        # Defines attributes with reader and writer methods. These values of these attributes
        #   are set
        # requires a :root option - a String or Symbol, the method on the instance to call to get the root.
        def attr_persister(*args, **opts)
          persistent_attributes |= args.flatten
          args.flatten.each do |attribute|
            @metadata_store_root = opts[:root] || opts ['root'] || raise("The :root option is required!")

            define_method(attribute) do
              store[attribute]
            end

            define_method("#{attribute}=") do |value|
              store[attribute] = value
            end
          end
        end

        def persistent_attributes
          @persistent_attributes ||= []
        end

        def metadata_store_root
          @metadata_store_root
        end
      end
    end
  end
end
