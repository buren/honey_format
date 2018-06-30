# frozen_string_literal: true

module HoneyFormat
  # Represents CSV.
  class Matrix
    # Instantiate CSV.
    # @return [CSV] a new instance of Matrix.
    # @param [Array<Array<String, nil>>] matrix
    # @param [Array<String>] header optional argument that represents header,
    #                        required if the matrix lacks a header row.
    # @param [#call] header_converter converts header columns.
    # @param [#call] row_builder will be called for each parsed row.
    # @param type_map [Hash] map of column_name => type conversion to perform.
    # @raise [HeaderError] super class of errors raised when there is a header error.
    # @raise [MissingHeaderError] raised when header is missing (empty or nil).
    # @raise [MissingHeaderColumnError] raised when header column is missing.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when row columns are empty.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    # @example
    #   matrix = HoneyFormat::Matrix.new([%w[name id]])
    # @example With custom header converter
    #   converter = proc { |v| v == 'name' ? 'first_name' : v }
    #   matrix = HoneyFormat::Matrix.new([%w[name id]], header_converter: converter)
    #   matrix.columns # => [:first_name, :id]
    # @example Handle errors
    #   begin
    #     matrix = HoneyFormat::Matrix.new([%w[name id]])
    #   rescue HoneyFormat::HeaderError => e
    #     puts "header error: #{e.class}, #{e.message}"
    #   rescue HoneyFormat::RowError => e
    #     puts "row error: #{e.class}, #{e.message}"
    #   end
    def initialize(
      matrix,
      header: nil,
      header_converter: HoneyFormat.header_converter,
      row_builder: nil,
      type_map: {}
    )
      header_row = header || matrix.shift
      @header = Header.new(header_row, converter: header_converter)
      @rows = Rows.new(matrix, columns, builder: row_builder, type_map: type_map)
    end

    # Original CSV header
    # @return [Header] object representing the CSV header.
    def header
      @header
    end

    # CSV columns converted from the original CSV header
    # @return [Array<Symbol>] of column identifiers.
    def columns
      @header.to_a
    end

    # @return [Rows] of rows.
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

    # rubocop:disable Metrics/LineLength
    # Convert matrix to CSV-string.
    # @param columns [Array<Symbol>, Set<Symbol>, NilClass] the columns to output, nil means all columns (default: nil)
    # @yield [row] The given block will be passed for every row - return truthy if you want the row to be included in the output
    # @yieldparam [Row] row
    # @return [String] CSV-string representation.
    # @example with selected columns
    #   matrix.to_csv(columns: [:id, :country])
    # @example with selected rows
    #   matrix.to_csv { |row| row.country == 'Sweden' }
    # @example with both selected columns and rows
    #   matrix.to_csv(columns: [:id, :country]) { |row| row.country == 'Sweden' }
    # rubocop:enable Metrics/LineLength
    def to_csv(columns: nil, &block)
      columns = columns&.map(&:to_sym)
      @header.to_csv(columns: columns) + @rows.to_csv(columns: columns, &block)
    end
  end
end
