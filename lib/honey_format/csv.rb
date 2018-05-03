require 'csv'

require 'honey_format/sanitize'
require 'honey_format/rows'
require 'honey_format/header'

module HoneyFormat
  # Represents CSV.
  class CSV
    # @return [CSV] a new instance of CSV.
    # @param [String] csv string.
    # @param [Array] valid_columns valid array of symbols representing valid columns.
    # @param [Array] header optional argument for CSV header
    # @param [#call] row_builder will be called for each parsed row
    # @raise [MissingCSVHeaderError] raised when header is missing (empty or nil).
    # @raise [MissingCSVHeaderColumnError] raised when header column is missing.
    # @raise [UnknownCSVHeaderColumnError] raised when column is not in valid list.
    def initialize(csv, delimiter: ',', header: nil, valid_columns: :all, header_converter: ConvertHeaderValue, row_builder: nil)
      csv = ::CSV.parse(csv, col_sep: delimiter)
      @csv_body = csv
      @header = Header.new(header || csv.shift, valid: valid_columns, converter: header_converter)
      @row_builder = row_builder
    end

    # @return [Array] of strings for sanitized header.
    def header
      @header.column_names
    end

    # @return [Array] of column identifiers.
    def columns
      @header.columns
    end

    # @return [Array] of rows.
    # @raise [InvalidRowLengthError] raised when there are more row elements longer than columns
    def rows
      @rows ||= Rows.new(@csv_body, columns, builder: @row_builder).to_a
    end

    # @yield [row] block to receive the row.
    def each_row
      rows.each { |row| yield(row) }
    end
  end
end
