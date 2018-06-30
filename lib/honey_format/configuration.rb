# frozen_string_literal: true

module HoneyFormat
  # Holds HoneyFormat configuration
  class Configuration
    # Instantiate configuration
    def initialize
      @converter = nil
      @header_converter = nil
    end

    # Returns the header converter
    # @return [#call] header_converter the configured header converter
    def header_converter
      @header_converter ||= converter[:header_column]
    end

    # Set the header converter
    # @param [Symbol, #call] converter for registered value converter or object that
    #                        responds to #call
    # @return [#call] the header converter
    def header_converter=(converter)
      @header_converter = if converter.is_a?(Symbol)
                            self.converter[converter]
                          else
                            converter
                          end
    end

    # Returns the value converter
    # @attr_reader [#call] converter the configured value converter
    def converter
      @converter ||= ValueConverter.new
    end

    # Default value converters
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
        header_column: ConvertHeaderColumn
      }.freeze
    end
  end
end
