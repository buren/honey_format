# frozen_string_literal: true

module HoneyFormat
  # Registry that holds value callers
  class Registry
    # Instantiate a caller registry
    # @param [Hash] default hash of defaults
    def initialize(default = {})
      @callers = nil
      @default = default.dup
      reset!
    end

    # Returns list of registered types
    # @return [Array<Symbol>] list of registered types
    def types
      @callers.keys
    end

    # Register a caller
    # @param [Symbol, String] type the name of the type
    # @param [#call] caller that responds to #call
    # @return [Registry] returns self
    # @raise [TypeExistsError] if type is already registered
    def register(type, caller)
      self[type] = caller
      self
    end

    # Unregister a caller
    # @param [Symbol, String] type the name of the type
    # @return [Registry] returns self
    # @raise [UnknownTypeError] if type is already registered
    def unregister(type)
      unknown_type_error!(type) unless type?(type)
      @callers.delete(to_key(type))
      self
    end

    # Call value type
    # @param [Symbol, String] type the name of the type
    # @param [Object] value to be converted
    def call(value, type)
      self[type].call(value)
    end

    # Register a caller
    # @param [Symbol, String] type the name of the type
    # @param [#call] caller that responds to #call
    # @return [Object] returns the caller
    # @raise [TypeExistsError] if type is already registered
    def []=(type, caller)
      type = to_key(type)

      if type?(type)
        raise(Errors::TypeExistsError, "type '#{type}' already exists")
      end

      @callers[type] = caller
    end

    # Returns the given type or raises error if type doesn't exist
    # @param [Symbol, String] type the name of the type
    # @return [Object] returns the caller
    # @raise [UnknownTypeError] if type does not exist
    def [](type)
      @callers.fetch(to_key(type)) { unknown_type_error!(type) }
    end

    # Returns true if the type exists, false otherwise
    # @param [Symbol, String] type the name of the type
    # @return [true, false] true if type exists, false otherwise
    def type?(type)
      return false unless keyable?(type)

      @callers.key?(to_key(type))
    end

    # Resets the caller registry to its default configuration
    # @return [Registry] returns the caller registry
    def reset!
      @callers = @default.dup
      self
    end

    private

    def keyable?(key)
      key.respond_to?(:to_sym)
    end

    def to_key(key)
      key.to_sym
    end

    def unknown_type_error!(type)
      raise(Errors::UnknownTypeError, "unknown type '#{type}'")
    end
  end
end
