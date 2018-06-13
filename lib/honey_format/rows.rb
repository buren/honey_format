require 'set'
require 'honey_format/row_builder'

module HoneyFormat
  # Represents rows.
  # @attr_reader [Hash] type_map map of column_name => type conversion to perform.
  class Rows
    include Enumerable

    # Returns array of cleaned strings.
    # @return [Rows] new instance of Rows.
    # @param [Array] rows the array of rows.
    # @param [Header, Array<Symbol>] columns the header or an array of column symbols.
    # @param type_map [Hash] map of column_name => type conversion to perform.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when there are no columns.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    def initialize(rows, columns, builder: nil, type_map: {})
      @type_map = type_map
      @custom_builder = builder
      @builder = RowBuilder.new(columns, builder: builder, type_map: type_map)
      @rows = prepare_rows(rows)
    end

    def add(row)
      row = prepare_row(row)
      @rows << row if row
    end
    alias_method :<<, :add

    # @yield [row] The given block will be passed for every row.
    # @yieldparam [Row] a row in the CSV file.
    # @return [Enumerator]
    #   If no block is given, an enumerator object will be returned.
    def each(&block)
      @rows.each(&block)
    end

    # Returns rows as array.
    # @return [Array] of rows.
    def to_a
      @rows
    end

    # Returns true if rows contains no elements.
    # @return [true, false] true if rows contains no elements.
    def empty?
      @rows.empty?
    end

    # Return the number of rows
    # @return [Integer] the number of rows
    def length
      @rows.length
    end
    alias_method :size, :length

    # @param columns [Array<Symbol>, Set<Symbol>, NilClass] the columns to output, nil means all columns (default: nil)
    # @yield [row] each row - return truthy if you want the row to be included in the output
    # @yieldparam [Row] row
    # @return [String] CSV-string representation.
    # @example with selected columns
    #   rows.to_csv(columns: [:id, :country])
    # @example with selected rows
    #   rows.to_csv { |row| row.country == 'Sweden' }
    # @example with both selected columns and rows
    #   csv.to_csv(columns: [:id, :country]) { |row| row.country == 'Sweden' }
    def to_csv(columns: nil, &block)
      # Convert columns to Set for performance
      columns = Set.new(columns.map(&:to_sym)) if columns
      csv_rows = []
      each do |row|
        if !block || block.call(row)
          csv_rows << row.to_csv(columns: columns)
        end
      end
      csv_rows.join
    end

    private

    def builder
      @builder ||= RowBuilder.new(columns, builder: @custom_builder, type_map: type_map)
    end

    def prepare_rows(rows)
      built_rows = []
      rows.each do |row|
        # ignore empty rows
        row = prepare_row(row) || next
        built_rows << row
      end
      built_rows
    end

    def prepare_row(row)
      return if row.nil? || row.empty? || row == [nil]
      builder.build(row)
    end
  end
end
