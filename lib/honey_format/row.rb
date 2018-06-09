require 'honey_format/row_builder'

module HoneyFormat
  # Holds data for a single row.
  class Row
    # Returns a new instance of Row.
    # @return [Row] a new instance of Row.
    # @param [Array] columns an array of symbols.
    # @param builder [#call, #to_csv] optional row builder
    # @raise [EmptyRowColumnsError] raised when there are no columns.
    # @example Create new row
    #     Row.new!([:id])
    def initialize(columns, builder: nil)
      if columns.empty?
        err_msg = 'Expected array with at least one element, but was empty.'
        raise(EmptyRowColumnsError, err_msg)
      end

      @row_builder = RowBuilder.new(*columns)
      @builder = builder
      @columns = columns
    end

    # Returns a Struct.
    # @return [Struct] a new instance of Row.
    # @param row [Array] the row array.
    # @raise [InvalidRowLengthError] raised when there are more row elements longer than columns
    # @example Build new row
    #     r = Row.new([:id])
    #     r.build(['1']).id #=> '1'
    def build(row)
      built_row = @row_builder.call(row)
      return built_row unless @builder
      @builder.call(built_row)
    rescue ArgumentError => e
      raise unless e.message == 'struct size differs'

      err_msg = [
        "Row length #{row.length}",
        "column length #{@columns.length}",
        "row: #{row.inspect}",
        "orignal message: '#{e.message}'"
      ].join(', ')
      raise(InvalidRowLengthError, err_msg)
    end
  end
end
