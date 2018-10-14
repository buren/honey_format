# frozen_string_literal: true

require 'set'

module HoneyFormat
  # Represents rows.
  class Rows
    include Enumerable

    # Returns array of cleaned strings.
    # @return [Rows] new instance of Rows.
    # @param [Array] rows the array of rows.
    # @param [Array<Symbol>] columns the array of column symbols.
    # @param type_map [Hash] map of column_name => type conversion to perform.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when there are no columns.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    def initialize(rows, columns, builder: nil, type_map: {})
      builder = RowBuilder.new(columns, builder: builder, type_map: type_map)
      @rows = prepare_rows(builder, rows)
    end

    # Returns true if rows contains no elements.
    # @return [true, false] true if rows contains no elements.
    def empty?
      @rows.empty?
    end

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

    # Return the number of rows
    # @return [Integer] the number of rows
    def length
      @rows.length
    end
    alias_method :size, :length

    # @param columns [Array<Symbol>, Set<Symbol>, NilClass]
    #   the columns to output, nil means all columns (default: nil)
    # @yield [row]
    #   each row - return truthy if you want the row to be included in the output
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
        if !block || yield(row)
          csv_rows << row.to_csv(columns: columns)
        end
      end
      csv_rows.join
    end

    private

    def prepare_rows(builder, rows)
      built_rows = []
      rows.each do |row|
        # ignore empty rows
        next if row.nil? || row.empty? || row == [nil]

        built_rows << builder.build(row)
      end
      built_rows
    end
  end
end
