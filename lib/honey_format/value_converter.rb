require "date"
require "time"
require "set"

module HoneyFormat
  class ValueConverter
    DEFAULT_CONVERTERS = {
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
    }.freeze

    def initialize
      @converters = DEFAULT_CONVERTERS.dup
    end

    def types
      @converters.keys
    end

    # Register a value converter
    # @param [Symbol, String] type the name of the type
    # @param [#call] converter that responds to #call
    # @return [ValueConverter] returns self
    # @raise [ValueTypeExistsError] if type is already registered
    def register(type, converter)
      self[type] = converter
      self
    end

    # Coerce value
    # @param [Symbol, String] type the name of the type
    # @param [Object] value to be converted
    def convert(value, type)
      self[type].call(value)
    end

    # Register a value converter
    # @param [Symbol, String] type the name of the type
    # @param [#call] converter that responds to #call
    # @return [Object] returns the converter
    # @raise [ValueTypeExistsError] if type is already registered
    def []=(type, converter)
      type = type.to_sym

      if type?(type)
        raise(Errors::ValueTypeExistsError, "type '#{type}' already exists")
      end

      @converters[type] = converter
    end

    # @param [Symbol, String] type the name of the type
    # @return [Object] returns the converter
    # @raise [UnknownValueTypeError] if type does not exist
    def [](type)
      @converters.fetch(type.to_sym) do
        raise(Errors::UnknownValueTypeError, "unknown type '#{type}'")
      end
    end

    # @param [Symbol, String] type the name of the type
    # @return [true, false] true if type exists, false otherwise
    def type?(type)
      @converters.key?(type.to_sym)
    end
  end
end
