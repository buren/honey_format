require 'date'
require 'time'
require 'set'
require 'digest'

require 'honey_format/header_column_converter'

module HoneyFormat
  # Converts values
  class ValueConverter
    # String values considered truthy
    TRUTHY = Set.new(%w[t T 1 y Y true TRUE]).freeze
    # String values considered falsy
    FALSY = Set.new(%w[f F 0 n N false FALSE]).freeze

    # Tries to convert value boolean to, returns nil if it can't convert
    CONVERT_BOOLEAN = lambda { |v|
      value = v&.downcase
      if TRUTHY.include?(value)
        true
      elsif FALSY.include?(value)
        false
      else
        nil
      end
    }

    # Default value converters
    DEFAULT_CONVERTERS = {
      # strict variants
      decimal!: proc { |v| Float(v) },
      integer!: proc { |v| Integer(v) },
      date!: proc { |v| Date.parse(v) },
      datetime!: proc { |v| Time.parse(v) },
      symbol!: proc { |v| v&.to_sym || raise(ArgumentError, "can't convert nil to symbol") },
      downcase!: proc { |v| v&.downcase || raise(ArgumentError, "can't convert nil to downcased string") },
      upcase!: proc { |v| v&.upcase || raise(ArgumentError, "can't convert nil to upcased string") },
      boolean!: proc { |v|
        value = CONVERT_BOOLEAN.call(v)
        raise(ArgumentError, "can't convert #{v} to boolean") if value.nil?
        value
      },
      # safe variants
      decimal: proc { |v| Float(v) rescue nil },
      decimal_or_zero: proc { |v| Float(v) rescue 0.0 },
      integer: proc { |v| Integer(v) rescue nil },
      integer_or_zero: proc { |v| Integer(v) rescue 0 },
      date: proc { |v| Date.parse(v) rescue nil },
      datetime: proc { |v| Time.parse(v) rescue nil },
      symbol: proc { |v| v&.to_sym },
      downcase: proc { |v| v&.downcase },
      upcase: proc { |v| v&.upcase },
      boolean: proc { |v| CONVERT_BOOLEAN.call(v) },
      md5: proc { |v| Digest::MD5.hexdigest(v) if v },
      nil: proc {},
      header_column: HeaderColumnConverter,
    }.freeze

    # Instantiate a value converter
    def initialize
      @converters = DEFAULT_CONVERTERS.dup
    end

    # Returns list of registered types
    # @return [Array<Symbol>] list of registered types
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

    # Convert value
    # @param [Symbol, String] type the name of the type
    # @param [Object] value to be converted
    def call(value, type)
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
