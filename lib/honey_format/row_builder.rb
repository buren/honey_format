require 'honey_format/row'

module HoneyFormat
  # Holds data for a single row.
  class RowBuilder
    # Returns a new instance of RowBuilder.
    # @return [RowBuilder] a new instance of RowBuilder.
    # @param [Array<Symbol>] columns an array of symbols.
    # @param builder [#call, #to_csv] optional row builder
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when there are no columns.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    # @example Create new row
    #     RowBuilder.new!([:id])
    def initialize(columns, builder: nil)
      if columns.empty?
        err_msg = 'Expected array with at least one element, but was empty.'
        raise(Errors::EmptyRowColumnsError, err_msg)
      end

      @row_klass = Row.new(*columns)
      @builder = builder
      @columns = columns
    end

    # Returns a Struct.
    # @return [Row, Object] a new instance of built row.
    # @param row [Array] the row array.
    # @raise [InvalidRowLengthError] raised when there are more row elements longer than columns
    # @example Build new row
    #     r = RowBuilder.new([:id])
    #     r.build(['1']).id #=> '1'
    def build(row)
      row = @row_klass.call(row)
      return row unless @builder
      @builder.call(row)
    rescue ArgumentError => e
      raise unless e.message == 'struct size differs'

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
