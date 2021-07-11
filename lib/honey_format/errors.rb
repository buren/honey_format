# frozen_string_literal: true

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
    # Raised when header column duplicate is found
    class DuplicateHeaderColumnError < HeaderError; end
    # Raised when deduplication strategy is unknown
    class UnknownDeduplicationStrategyError < HeaderError; end

    # Row errors
    # Super class of errors raised when there is a row error
    class RowError < StandardError; end
    # Raised when row columns are empty
    class EmptyRowColumnsError < RowError; end
    # Raised when row has more columns than header columns
    class InvalidRowLengthError < RowError; end

    # Value conversion errors
    # Raised when value type is unknown
    class UnknownTypeError < ArgumentError; end
    # Raised when value type already exists
    class TypeExistsError < ArgumentError; end

    # Converter errors
    # Rasied when babosa gem is not installed and converter was used
    class BabosaNotLoadedError < ArgumentError; end
  end

  include Errors
end
