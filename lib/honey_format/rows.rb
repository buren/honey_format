require 'honey_format/row'

module HoneyFormat
  # Represents rows.
  class Rows
    include Enumerable

    # Returns array of cleaned strings.
    # @return [Rows] new instance of Rows.
    # @param [Array] rows the array of rows.
    # @param [Array] columns the array of column symbols.
    def initialize(rows, columns, builder: nil)
      @rows = prepare_rows(Row.new(columns, builder: builder), rows)
    end

    # @yield [row] The given block will be passed every row.
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

    # @return [String] CSV-string representation.
    def to_csv
      to_a.map(&:to_csv).join
    end

    private

    def prepare_rows(builder, rows)
      built_rows = []
      rows.each do |row|
        # ignore empty rows - the Ruby CSV library can return empty lines as [nil]
        next if row.empty? || row.nil? || row == [nil]
        built_rows << builder.build(Sanitize.array!(row))
      end
      built_rows
    end
  end
end
