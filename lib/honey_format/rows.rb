require 'honey_format/row'

module HoneyFormat
  class Rows
    include Enumerable

    def initialize(rows, columns)
      @rows = rows
      @row = Row.new(columns)
    end

    def each
      @rows.each { |row| yield(prepare_row(row)) }
    end

    private

    def prepare_row(row)
      @row.build(Clean.row(row))
    end
  end
end
