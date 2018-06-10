require 'csv'

require 'honey_format/rows'
require 'honey_format/header'

module HoneyFormat
  # Represents CSV.
  class CSV
    # Instantiate CSV.
    # @return [CSV] a new instance of CSV.
    # @param [String] csv the CSV string
    # @param [String] delimiter the CSV delimiter
    # @param [Array<String>] header optional argument that represents CSV header, required if the CSV file lacks a header row.
    # @param [Array<Symbol>] valid_columns array of symbols representing valid columns, if empty all will be considered valid.
    # @param [#call] header_converter converts header columns.
    # @param [#call] row_builder will be called for each parsed row.
    # @raise [HeaderError] super class of errors raised when there is a CSV header error.
    # @raise [MissingHeaderError] raised when header is missing (empty or nil).
    # @raise [MissingHeaderColumnError] raised when header column is missing.
    # @raise [UnknownHeaderColumnError] raised when column is not in valid list.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when row columns are empty.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
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

    # CSV columns converted from the original CSV header
    # @return [Array<Symbol>] of column identifiers.
    def columns
      @header.to_a
    end

    # @return [Array] of rows.
    def rows
      @rows
    end

    # @yield [row] The given block will be passed for every row.
    # @yieldparam [Row] row in the CSV.
    # @return [Enumerator] If no block is given, an enumerator object will be returned.
    def each_row
      return rows.each unless block_given?

      rows.each { |row| yield(row) }
    end

    # Convert CSV object as CSV-string.
    # @param columns [Array<Symbol>, Set<Symbol>, NilClass] the columns to output, nil means all columns (default: nil)
    # @yield [row] The given block will be passed for every row - return truthy if you want the row to be included in the output
    # @yieldparam [Row] row
    # @return [String] CSV-string representation.
    # @example with selected columns
    #   csv.to_csv(columns: [:id, :country])
    # @example with selected rows
    #   csv.to_csv { |row| row.country == 'Sweden' }
    # @example with both selected columns and rows
    #   csv.to_csv(columns: [:id, :country]) { |row| row.country == 'Sweden' }
    def to_csv(columns: nil, &block)
      @header.to_csv(columns: columns) + @rows.to_csv(columns: columns, &block)
    end
  end
end
