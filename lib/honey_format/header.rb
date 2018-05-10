require 'honey_format/columns'

module HoneyFormat
  # Represents a header
  class Header
    attr_reader :column_names

    # @return [Header] a new instance of Header.
    # @param [Array] header array of strings.
    # @param [Array] valid array of symbols representing valid columns.
    # @raise [MissingCSVHeaderError] raised when header is missing (empty or nil).
    def initialize(header, valid: :all, converter: ConvertHeaderValue)
      if header.nil? || header.empty?
        fail(MissingCSVHeaderError, "CSV header can't be empty.")
      end

      @column_names = Sanitize.array(header)
      @columns = Columns.new(@column_names, valid: valid, converter: converter)
    end

    # Returns columns as array.
    # @return [Array] of columns.
    def columns
      @columns.to_a
    end

    # @return [String] CSV-string representation.
    def to_csv
      columns.to_csv
    end
  end
end
