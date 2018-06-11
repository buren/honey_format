module HoneyFormat
  # Errors
  module Errors
    # Header errors
    # Super class of errors raised when there is a header error
    class HeaderError < StandardError; end
    # Raised when header is missing
    class MissingHeaderError < HeaderError; end
    # Raised when header column is missing
    class MissingHeaderColumnError < HeaderError; end
    # Raised when a column is not in passed valid columns
    class UnknownHeaderColumnError < HeaderError; end

    # Row errors
    # Super class of errors raised when there is a row error
    class RowError < StandardError; end
    # Raised when row columns are empty
    class EmptyRowColumnsError < RowError; end
    # Raised when row has more columns than header columns
    class InvalidRowLengthError < RowError; end

    # Value coercion errors
    # Raised when value type is unknown
    class UnknownValueTypeError < ArgumentError; end
    # Raised when value type already exists
    class ValueTypeExistsError < ArgumentError; end
  end

  include Errors
end
