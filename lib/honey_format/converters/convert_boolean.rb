# frozen_string_literal: true

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

  # Convert to boolean or raise error
  StrictConvertBoolean = proc do |v|
    ConvertBoolean.call(v).tap do |value|
      raise(ArgumentError, "can't convert #{v} to boolean") if value.nil?
    end
  end
end
