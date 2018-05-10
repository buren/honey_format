module HoneyFormat
  # Holds data for a single row.
  class Row
    class RowBuilder < Struct
      def self.call(row)
        new(*row)
      end

      # @return [String] CSV-string representation.
      def to_csv
        members.map do |column_name|
          column = public_send(column_name)
          if column.respond_to?(:to_csv)
            column.to_csv
          else
            column.to_s
          end
        end.join(',') + "\n"
      end
    end

    # Returns a new instance of Row.
    # @return [Row] a new instance of Row.
    # @param [Array] columns an array of symbols.
    # @param builder [#call, #to_csv] optional row builder
    # @raise [EmptyColumnsError] raised when there are no columns.
    # @example Create new row
    #     Row.new!([:id])
    def initialize(columns, builder: nil)
      validate_columns!(columns)
      @row_builder = RowBuilder.new(*columns)
      @builder = builder || ->(row) { row }
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
      @builder.call(built_row)
    rescue ArgumentError, 'struct size differs'
      fail_for_struct_size_diff!(row)
    end

    private

    def validate_columns!(columns)
      return unless columns.empty?

      err_msg = 'Expected array with at least one element, but was empty.'
      fail(EmptyColumnsError, err_msg)
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
