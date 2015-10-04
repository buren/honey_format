require 'honey_format/row'

module HoneyFormat
  class Rows
    include Enumerable

    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @row = Row.new(columns)
    end


    def each
      @rows.each do |row|
        validate_row!(row)
        yield(@row.build(Clean.row(row)))
      end
    end

    def validate_row!(row)
      row.length == @columns.length ||
        begin
          err_msg = "Invalid row. Row length is #{row.length} and header length #{@columns.length} for row #{row}"
          fail(InvalidCSVRowLengthError, err_msg)
        end
    end
  end
end
