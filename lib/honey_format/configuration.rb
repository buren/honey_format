# frozen_string_literal: true

require 'honey_format/helpers/helpers'

module HoneyFormat
  # Holds HoneyFormat configuration
  class Configuration
    # Instantiate configuration
    def initialize
      @converter = nil
      @header_converter = nil
      @deduplicate_header = nil
    end

    # Returns the header converter
    # @return [#call] header_converter the configured header converter
    def header_converter
      @header_converter ||= converter[:header_column]
    end

    # Set the header converter
    # @param [Symbol, #call] converter for registered converter registry or object that
    #                        responds to #call
    # @return [#call] the header converter
    def header_converter=(converter)
      @header_converter = if converter.is_a?(Symbol)
                            self.converter[converter]
                          else
                            converter
                          end
    end

    # Return the deduplication header strategy
    # @return [#call] the header deduplication strategy
    def deduplicate_header
      @deduplicate_header ||= header_deduplicator[:deduplicate]
    end

    # Set the deduplication header strategy
    # @param [Symbol, #call]
    #   symbol with known strategy identifier or method that responds
    #   to #call(colums, key_count)
    # @return [#call] the header deduplication strategy
    # @raise [UnknownDeduplicationStrategyError]
    def deduplicate_header=(strategy)
      if header_deduplicator.type?(strategy)
        @deduplicate_header = header_deduplicator[strategy]
      elsif strategy.respond_to?(:call)
        @deduplicate_header = strategy
      else
        message = "unknown deduplication strategy: '#{strategy}'"
        raise(Errors::UnknownDeduplicationStrategyError, message)
      end
    end

    # Default header deduplicate strategies
    # @return [Hash] the default header deduplicatation strategies
    def default_deduplicate_header_strategies
      @default_deduplicate_header_strategies ||= {
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
    def header_deduplicator
      @header_deduplicator ||= Registry.new(default_deduplicate_header_strategies)
    end

    # Returns the converter registry
    # @return [#call] converter the configured converter registry
    def converter
      @converter ||= Registry.new(default_converters)
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
      }.freeze
    end
  end
end
