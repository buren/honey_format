require 'csv'

require 'honey_format/rows'
require 'honey_format/header'

module HoneyFormat
  # Represents CSV.
  class CSV
    # @return [CSV] a new instance of CSV.
    # @param [String] csv string.
    # @param [Array<Symbol>] valid_columns valid array of symbols representing valid columns if empty all will be considered valid.
    # @param [Array<String>] header optional argument for CSV header
    # @param [#call] row_builder will be called for each parsed row
    # @raise [MissingCSVHeaderError] raised when header is missing (empty or nil).
    # @raise [MissingCSVHeaderColumnError] raised when header column is missing.
    # @raise [UnknownCSVHeaderColumnError] raised when column is not in valid list.
    def initialize(csv, delimiter: ',', header: nil, valid_columns: [], header_converter: ConvertHeaderValue, row_builder: nil)
      csv = ::CSV.parse(csv, col_sep: delimiter)
      header_row = header || csv.shift
      @header = Header.new(header_row, valid: valid_columns, converter: header_converter)
      @rows = Rows.new(csv, columns, builder: row_builder)
    end

    # Original CSV header
    # @return [Array<String>] of strings for sanitized header.
    def header
      @header.original
    end

    # CSV columns
    # @return [Array<Symbol>] of column identifiers.
    def columns
      @header.to_a
    end

    # @return [Array] of rows.
    # @raise [InvalidRowLengthError] raised when there are more row elements longer than columns
    def rows
      @rows
    end

    # @yield [row] The given block will be passed for every row.
    # @yieldparam [Row] a colmn in the CSV header.
    # @return [Enumerator] If no block is given, an enumerator object will be returned.
    def each_row
      return rows.each unless block_given?

      rows.each { |row| yield(row) }
    end

    # Convert CSV object as CSV-string.
    # @return [String] CSV-string representation.
    def to_csv
      header.to_csv + @rows.to_csv
    end
  end
end
