# frozen_string_literal: true

require 'date'
require 'time'

module HoneyFormat
  # Convert to date
  ConvertDate = proc do |v|
    begin
      StrictConvertDate.call(v)
    rescue ArgumentError, TypeError
      nil
    end
  end

  # Convert to datetime
  ConvertDatetime = proc do |v|
    begin
      StrictConvertDatetime.call(v)
    rescue ArgumentError, TypeError
      nil
    end
  end

  # Convert to date or raise error
  StrictConvertDate = proc { |v| Date.parse(v) }

  # Convert to datetime or raise error
  StrictConvertDatetime = proc { |v| Time.parse(v) }
end
