module HoneyFormat
  # Default row builder
  class RowBuilder < Struct
    # Create a row
    # @return [Struct] returns an instantiated Struct representing a row
    def self.call(row)
      new(*row)
    end

    # Represent row as CSV
    # @param columns [Array<Symbol>, Set<Symbol>, NilClass] the columns to output, nil means all columns (default: nil)
    # @return [String] CSV-string representation.
    def to_csv(columns: nil)
      attributes = members
      attributes = columns & attributes if columns

      row = attributes.map do |column_name|
        column = public_send(column_name)
        next column.to_csv if column.respond_to?(:to_csv)
        next if column.nil?

        column.to_s
      end

      ::CSV.generate_line(row)
    end
  end
end
