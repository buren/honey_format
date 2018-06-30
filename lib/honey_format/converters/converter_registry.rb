# frozen_string_literal: true

module HoneyFormat
  # Convert registry that holds value converters
  class ConverterRegistry
    # Instantiate a converter registry
    # @param [Hash] default_converters hash of default converters
    def initialize(default_converters = HoneyFormat.config.default_converters)
      @converters = nil
      @default = default_converters.dup
      reset!
    end

    # Returns list of registered types
    # @return [Array<Symbol>] list of registered types
    def types
      @converters.keys
    end

    # Register a converter
    # @param [Symbol, String] type the name of the type
    # @param [#call] converter that responds to #call
    # @return [ConverterRegistry] returns self
    # @raise [ValueTypeExistsError] if type is already registered
    def register(type, converter)
      self[type] = converter
      self
    end

    # Unregister a converter
    # @param [Symbol, String] type the name of the type
    # @return [ConverterRegistry] returns self
    # @raise [UnknownTypeError] if type is already registered
    def unregister(type)
      unknown_type_error!(type) unless type?(type)
      @converters.delete(to_key(type))
      self
    end

    # Convert value
    # @param [Symbol, String] type the name of the type
    # @param [Object] value to be converted
    def call(value, type)
      self[type].call(value)
    end

    # Register a converter
    # @param [Symbol, String] type the name of the type
    # @param [#call] converter that responds to #call
    # @return [Object] returns the converter
    # @raise [ValueTypeExistsError] if type is already registered
    def []=(type, converter)
      type = to_key(type)

      if type?(type)
        raise(Errors::ValueTypeExistsError, "type '#{type}' already exists")
      end

      @converters[type] = converter
    end

    # Returns the given type or raises error if type doesn't exist
    # @param [Symbol, String] type the name of the type
    # @return [Object] returns the converter
    # @raise [UnknownTypeError] if type does not exist
    def [](type)
      @converters.fetch(to_key(type)) { unknown_type_error!(type) }
    end

    # Returns true if the type exists, false otherwise
    # @param [Symbol, String] type the name of the type
    # @return [true, false] true if type exists, false otherwise
    def type?(type)
      @converters.key?(to_key(type))
    end

    # Resets the converter registry to its default configuration
    # @return [ConverterRegistry] returns the converter registry
    def reset!
      @converters = @default.dup
      self
    end

    private

    def to_key(key)
      key.to_sym
    end

    def unknown_type_error!(type)
      raise(Errors::UnknownTypeError, "unknown type '#{type}'")
    end
  end
end
