# frozen_string_literal: true

require 'honey_format/helpers/helpers'

module HoneyFormat
  # Holds HoneyFormat configuration
  # @attr_accessor [String] delimiter the default column delimiter (default: ,)
  # @attr_accessor [String, Symbol] row_delimiter the default row delimiter (default: :auto)
  # @attr_accessor [String] quote_character the default quote character (default: ")
  # @attr_accessor [String, Regexp] skip_lines skip all lines matching pattern (default: nil)
  class Configuration
    attr_accessor :delimiter, :row_delimiter, :quote_character, :skip_lines

    # Instantiate configuration
    def initialize
      @converter_registry = nil
      @header_converter = nil
      @header_deduplicator = nil
      @delimiter = ','
      @row_delimiter = :auto
      @quote_character = '"'
      @skip_lines = nil
    end

    # Returns the header converter
    # @return [#call] header_converter the configured header converter
    def header_converter
      @header_converter ||= converter_registry[:header_column]
    end

    # Set the header converter
    # @param [Symbol, #call] converter for registered converter registry or object that
    #                        responds to #call
    # @return [#call] the header converter
    def header_converter=(converter)
      @header_converter = if converter.is_a?(Symbol)
                            converter_registry[converter]
                          else
                            converter
                          end
    end

    # Return the deduplication header strategy
    # @return [#call] the header deduplication strategy
    def header_deduplicator
      @header_deduplicator ||= header_deduplicator_registry[:deduplicate]
    end

    # Set the deduplication header strategy
    # @param [Symbol, #call]
    #   symbol with known strategy identifier or method that responds
    #   to #call(colums, key_count)
    # @return [#call] the header deduplication strategy
    # @raise [UnknownDeduplicationStrategyError]
    def header_deduplicator=(strategy)
      if header_deduplicator_registry.type?(strategy)
        @header_deduplicator = header_deduplicator_registry[strategy]
      elsif strategy.respond_to?(:call)
        @header_deduplicator = strategy
      else
        message = "unknown deduplication strategy: '#{strategy}'"
        raise(Errors::UnknownDeduplicationStrategyError, message)
      end
    end

    # Default header deduplicate strategies
    # @return [Hash] the default header deduplicatation strategies
    def default_header_deduplicators
      @default_header_deduplicators ||= {
        deduplicate: proc do |columns|
          Helpers.key_count_to_deduplicated_array(columns)
        end,
        raise: proc do |columns|
          duplicates = Helpers.duplicated_items(columns)
          if duplicates.any?
            message = "all columns must be unique, duplicates are: #{duplicates}"
            raise(Errors::DuplicateHeaderColumnError, message)
          end
          columns
        end,
        none: proc { |columns| columns },
      }.freeze
    end

    # Returns the column deduplication registry
    # @return [#call] column deduplication registry
    def header_deduplicator_registry
      @header_deduplicator_registry ||= Registry.new(default_header_deduplicators)
    end

    # Returns the converter registry
    # @return [#call] converter the configured converter registry
    def converter_registry
      @converter_registry ||= Registry.new(default_converters)
    end

    # Default converter registry
    # @return [Hash] hash with default converters
    def default_converters
      @default_converters ||= {
        # strict variants
        decimal!: StrictConvertDecimal,
        integer!: StrictConvertInteger,
        date!: StrictConvertDate,
        datetime!: StrictConvertDatetime,
        symbol!: StrictConvertSymbol,
        downcase!: StrictConvertDowncase,
        upcase!: StrictConvertUpcase,
        boolean!: StrictConvertBoolean,
        # safe variants
        decimal: ConvertDecimal,
        decimal_or_zero: ConvertDecimalOrZero,
        integer: ConvertInteger,
        integer_or_zero: ConvertIntegerOrZero,
        date: ConvertDate,
        datetime: ConvertDatetime,
        symbol: ConvertSymbol,
        downcase: ConvertDowncase,
        upcase: ConvertUpcase,
        boolean: ConvertBoolean,
        md5: ConvertMD5,
        hex: ConvertHex,
        nil: ConvertNil,
        blank: ConvertBlank,
        header_column: ConvertHeaderColumn,
        method_name: ConvertHeaderColumn,
      }.freeze
    end
  end
end
