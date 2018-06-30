# frozen_string_literal: true

module HoneyFormat
  # Holds data for a single row.
  class RowBuilder
    # Returns a new instance of RowBuilder.
    # @return [RowBuilder] a new instance of RowBuilder.
    # @param [Array<Symbol>] columns an array of symbols.
    # @param builder [#call, #to_csv] optional row builder.
    # @param type_map [Hash] map of column_name => type conversion to perform.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when there are no columns.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    # @example Create new row
    #     RowBuilder.new!([:id])
    def initialize(columns, builder: nil, type_map: {})
      if columns.empty?
        err_msg = 'Expected array with at least one element, but was empty.'
        raise(Errors::EmptyRowColumnsError, err_msg)
      end

      @type_map = type_map
      @converter = HoneyFormat.converter

      @row_klass = Row.new(*columns)
      @builder = builder
      @columns = columns
    end

    # Returns an object representing the row.
    # @return [Row, Object] a new instance of built row.
    # @param row [Array] the row array.
    # @raise [InvalidRowLengthError]
    #   raised when there are more row elements longer than columns
    # @example Build new row
    #     r = RowBuilder.new([:id])
    #     r.build(['1']).id #=> '1'
    def build(row)
      build_row!(row)
    rescue ArgumentError => e
      raise unless e.message == 'struct size differs'
      raise_invalid_row_length!(e, row)
    end

    private

    # Returns Struct
    # @return [Row, Object] a new instance of built row.
    # @param row [Array] the row array.
    # @raise [ArgumentError] raised when struct fails to build
    # @example Build new row
    #     r = RowBuilder.new([:id])
    #     r.build(['1']).id #=> '1'
    def build_row!(row)
      row = @row_klass.call(row)

      # Convert values
      @type_map.each do |column, type|
        row[column] = @converter.call(row[column], type)
      end

      return row unless @builder
      @builder.call(row)
    end

    # Raises invalid row length error
    # @param [StandardError] e the raised error
    # @param [Object] row
    # @raise [Errors::InvalidRowLengthError]
    def raise_invalid_row_length!(e, row)
      err_msg = [
        "Row length #{row.length}",
        "column length #{@columns.length}",
        "row: #{row.inspect}",
        "orignal message: '#{e.message}'"
      ].join(', ')
      raise(Errors::InvalidRowLengthError, err_msg)
    end
  end
end
