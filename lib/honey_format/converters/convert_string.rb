# frozen_string_literal: true

require 'digest'
require 'securerandom'

module HoneyFormat
  # Convert to downcase or nil
  ConvertDowncase = proc { |v| v&.downcase }

  # Convert to upcase or nil
  ConvertUpcase = proc { |v| v&.upcase }

  # Convert to symbol or nil
  ConvertSymbol = proc { |v| v&.to_sym }

  # Convert to md5 or nil
  ConvertMD5 = proc { |v| Digest::MD5.hexdigest(v) if v }

  # Convert to hex or nil
  ConvertHex = proc { |v| SecureRandom.hex if v }

  # Convert header column
  ConvertHeaderColumn = HeaderColumnConverter

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
