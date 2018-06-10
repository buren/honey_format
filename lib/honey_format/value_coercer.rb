require "date"
require "time"
require "set"

module HoneyFormat
  class ValueCoercer
    def initialize
      @coercers = {
        # strict variants
        decimal!: proc { |v| Float(v) },
        integer!: proc { |v| Integer(v) },
        date!: proc { |v| Date.parse(v) },
        datetime!: proc { |v| Time.parse(v) },
        # safe variants
        decimal: proc { |v| Float(v) rescue nil },
        integer: proc { |v| Integer(v) rescue nil },
        date: proc { |v| Date.parse(v) rescue nil },
        datetime: proc { |v| Time.parse(v) rescue nil },
      }
    end

    def types
      @coercers.keys
    end

    # Register a value coercer
    # @param [Symbol, String] type the name of the type
    # @param [#call] coercer that responds to #call
    # @return [ValueCoercer] returns self
    # @raise [ArgumentError] if type is already registered
    def register(type, coercer)
      self[type] = coercer
      self
    end

    # Coerce value
    # @param [Symbol, String] type the name of the type
    # @param [Object] value to be coerced
    def coerce(value, type)
      self[type].call(value)
    end

    # Register a value coercer
    # @param [Symbol, String] type the name of the type
    # @param [#call] coercer that responds to #call
    # @return [Object] returns the coercer
    # @raise [ArgumentError] if type is already registered
    def []=(type, coercer)
      type = type.to_sym

      if type?(type)
        raise(ArgumentError, "type '#{type}' already exists")
      end

      @coercers[type] = coercer
    end

    # @param [Symbol, String] type the name of the type
    # @return [Object] returns the coercer
    # @raise [ArgumentError] if type does not exist
    def [](type)
      @coercers.fetch(type.to_sym) do
        raise(ArgumentError, "unknown type '#{type}'")
      end
    end

    # @param [Symbol, String] type the name of the type
    # @return [true, false] true if type exists, false otherwise
    def type?(type)
      @coercers.key?(type.to_sym)
    end
  end
end
