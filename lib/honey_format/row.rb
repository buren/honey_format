module HoneyFormat
  class InvalidColumnsForRow  < ArgumentError; end
  class InvalidRowLengthError < ArgumentError; end

  class Row
    def initialize(columns)
      validate_columns!(columns)
      @klass = Struct.new(*columns)
      @columns = columns
    end

    def build(row)
      @klass.new(*row)
    rescue ArgumentError, 'struct size differs'
      fail_for_struct_size_diff!(row)
    end

    private

    def validate_columns!(columns)
      if columns.empty?
        err_msg = 'Expected array with at least one element, but was empty.'
        fail(InvalidColumnsForRow, err_msg)
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
