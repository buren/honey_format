# frozen_string_literal: true

module HoneyFormat
  # Converts decimal or nil
  ConvertDecimal = proc do |v|
    begin
      Float(v)
    rescue ArgumentError, TypeError
      nil
    end
  end

  # Converts to decimal or zero
  ConvertDecimalOrZero = proc { |v| v.to_f }

  # Convert to integer or nil
  ConvertInteger = proc do |v|
    begin
      Integer(v)
    rescue ArgumentError, TypeError
      nil
    end
  end

  # Convert to integer or zero
  ConvertIntegerOrZero = proc { |v| v.to_i }

  # Convert to decimal or raise error
  StrictConvertDecimal = proc { |v| Float(v) }

  # Convert to integer or raise error
  StrictConvertInteger = proc { |v| Integer(v) }
end
