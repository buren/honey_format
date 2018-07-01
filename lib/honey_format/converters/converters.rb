# frozen_string_literal: true

require 'honey_format/converters/header_column_converter'
require 'honey_format/converters/convert_boolean'
require 'honey_format/converters/convert_date_and_time'
require 'honey_format/converters/convert_number'
require 'honey_format/converters/convert_string'
require 'honey_format/converters/convert_babosa'

module HoneyFormat
  # Convert to nil
  ConvertNil = proc {}
end
