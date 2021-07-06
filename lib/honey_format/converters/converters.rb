# frozen_string_literal: true

require 'honey_format/converters/header_column_converter'
require 'honey_format/converters/convert_boolean'
require 'honey_format/converters/convert_date_and_time'
require 'honey_format/converters/convert_number'
require 'honey_format/converters/convert_string'

module HoneyFormat
  # Convert to nil
  ConvertNil = proc {}

  module Converters
    DEFAULT = {
      # strict variants
      decimal!: StrictConvertDecimal,
      integer!: StrictConvertInteger,
      date!: StrictConvertDate,
      datetime!: StrictConvertDatetime,
      symbol!: StrictConvertSymbol,
      downcase!: StrictConvertDowncase,
      upcase!: StrictConvertUpcase,
      strip!: StrictConvertStrip,
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
      strip: ConvertStrip,
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
