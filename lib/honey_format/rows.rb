require 'honey_format/row'

module HoneyFormat
  # Represents rows.
  class Rows
    # Returns array of cleaned strings.
    # @return [Rows] new instance of Rows.
    # @param [Array] rows the array of rows.
    # @param [Array] columns the array of column symbols.
    def initialize(rows, columns)
      @rows = prepare_rows(Row.new(columns), rows)
    end

    # Returns rows as array.
    # @return [Array] of rows.
    def to_a
      @rows
    end

    private

    def prepare_rows(builder, rows)
      built_rows = []
      rows.each do |row|
        unless row.first.nil? # The Ruby CSV library returns empty lines as [nil], ignore them..
          built_rows << builder.build(Sanitize.array!(row))
        end
      end
      built_rows
    end
  end
end
