module Bork
  module Metadata
    # requires that a #job_folder instance method be defined on the base class
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
        @store = Store.new(job_folder)
      end

      def persistent_attributes
        self.class.persistent_attributes
      end

      module ClassMethods
        def attr_persister(*args)
          persistent_attributes |= args.flatten
          args.flatten.each do |attribute|
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
      end
    end
  end
end
