module HoneyFormat
  # Raised when header is missing
  class MissingCSVHeaderError < StandardError; end
  # Raised when there is a CSV header column error
  class CSVHeaderColumnError < StandardError; end
  # Raised when header column is missing
  class MissingCSVHeaderColumnError < CSVHeaderColumnError; end
  # Raised when a column is not in passed valid columns
  class UnknownCSVHeaderColumnError < CSVHeaderColumnError; end
  # Raised when columns are empty
  class EmptyColumnsError < ArgumentError; end
  # Raised when row has more columns than columns
  class InvalidRowLengthError < ArgumentError; end
end
