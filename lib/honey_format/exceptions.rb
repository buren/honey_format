module HoneyFormat
  # Raised when header is missing
  class MissingCSVHeaderError < StandardError; end
  # Raised when header column is missing
  class MissingCSVHeaderColumnError < StandardError; end
  # Raised when a column is not in passed valid columns
  class UnknownCSVHeaderColumnError < StandardError; end
  # Raised when columns are empty
  class EmptyColumnsError < ArgumentError; end
  # Raised when row has more columns than columns
  class InvalidRowLengthError < ArgumentError; end
end
