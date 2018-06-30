# frozen_string_literal: true

require 'date'
require 'time'
require 'set'
require 'digest'
require 'securerandom'

require 'honey_format/converters/header_column_converter'

module HoneyFormat
  # String values considered truthy
  TRUTHY = Set.new(%w[t T 1 y Y true TRUE]).freeze
  # String values considered falsy
  FALSY = Set.new(%w[f F 0 n N false FALSE]).freeze

  # Tries to convert value boolean to, returns nil if it can't convert
  ConvertBoolean = proc do |v|
    if TRUTHY.include?(v)
      true
    elsif FALSY.include?(v)
      false
    end
  end

  # Converts decimal or nil
  ConvertDecimal = proc do |v|
    begin
      Float(v)
    rescue StandardError
      nil
    end
  end

  # Converts to decimal or zero
  ConvertDecimalOrZero = proc do |v|
    begin
      Float(v)
    rescue StandardError
      0.0
    end
  end

  # Convert to integer or nil
  ConvertInteger = proc do |v|
    begin
      Integer(v)
    rescue StandardError
      nil
    end
  end

  # Convert to integer or zero
  ConvertIntegerOrZero = proc do |v|
    begin
      Integer(v)
    rescue StandardError
      0
    end
  end

  # Convert to date
  ConvertDate = proc do |v|
    begin
      Date.parse(v)
    rescue StandardError
      nil
    end
  end

  # Convert to datetime
  ConvertDatetime = proc do |v|
    begin
      Time.parse(v)
    rescue StandardError
      nil
    end
  end

  # Convert to symbol or nil
  ConvertSymbol = proc { |v| v&.to_sym }

  # Convert to downcase or nil
  ConvertDowncase = proc { |v| v&.downcase }

  # Convert to upcase or nil
  ConvertUpcase = proc { |v| v&.upcase }

  # Convert to md5 or nil
  ConvertMD5 = proc { |v| Digest::MD5.hexdigest(v) if v }

  # Convert to hex or nil
  ConvertHex = proc { |v| SecureRandom.hex if v }

  # Convert header column
  ConvertHeaderColumn = HeaderColumnConverter

  # Convert to nil
  ConvertNil = proc {}

  # Convert to decimal or raise error
  StrictConvertDecimal = proc { |v| Float(v) }

  # Convert to integer or raise error
  StrictConvertInteger = proc { |v| Integer(v) }

  # Convert to date or raise error
  StrictConvertDate = proc { |v| Date.parse(v) }

  # Convert to datetime or raise error
  StrictConvertDatetime = proc { |v| Time.parse(v) }

  # Convert to boolean or raise error
  StrictConvertBoolean = proc do |v|
    ConvertBoolean.call(v).tap do |value|
      raise(ArgumentError, "can't convert #{v} to boolean") if value.nil?
    end
  end

  # Convert to upcase or raise error
  StrictConvertUpcase = proc do |v|
    ConvertUpcase.call(v) || raise(ArgumentError, "can't convert nil to upcased string")
  end

  # Convert to downcase or raise error
  StrictConvertDowncase = proc do |v|
    ConvertDowncase.call(v) || raise(ArgumentError, "can't convert nil to downcased string")
  end

  # Convert to symbol or raise error
  StrictConvertSymbol = proc do |v|
    ConvertSymbol.call(v) || raise(ArgumentError, "can't convert nil to symbol")
  end
end
