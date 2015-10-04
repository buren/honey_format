module HoneyFormat
  # Holds data for a single row.
  class Row
    # Returns a new instance of Row.
    # @return [Row] a new instance of Row.
    # @param [Array] columns an array of symbols.
    # @raise [EmptyColumnsError] raised when there are no columns.
    # @example Create new row
    #     Row.new!([:id])
    def initialize(columns)
      validate_columns!(columns)
      @klass = Struct.new(*columns)
      @columns = columns
    end

    # Returns a Struct.
    # @return [Struct] a new instance of Row.
    # @param row [Array] the row array.
    # @raise [InvalidRowLengthError] raised when there are more row elements longer than columns
    # @example Build new row
    #     r = Row.new!([:id])
    #     r.build(['1']).id #=> '1'
    def build(row)
      @klass.new(*row)
    rescue ArgumentError, 'struct size differs'
      fail_for_struct_size_diff!(row)
    end

    private

    def validate_columns!(columns)
      if columns.empty?
        err_msg = 'Expected array with at least one element, but was empty.'
        fail(EmptyColumnsError, err_msg)
      end
    end

    def fail_for_struct_size_diff!(row)
      err_msg = [
        "Row length #{row.length}",
        "for columns #{@columns.length}",
        "row: #{row.inspect}"
      ].join(', ')
      fail(InvalidRowLengthError, err_msg)
    end
  end
end
