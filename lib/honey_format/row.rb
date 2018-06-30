# frozen_string_literal: true

module HoneyFormat
  # Default row builder
  class Row < Struct
    # Create a row
    # @return [Struct] returns an instantiated Struct representing a row
    # @example
    #   row_klass = Row.new(:id, :username)
    #   row = row_klass.call('1', 'buren')
    #   # => #<struct id="1", username="buren">
    def self.call(row)
      new(*row)
    end

    # rubocop:disable Metrics/LineLength
    # Represent row as CSV
    # @param columns [Array<Symbol>, Set<Symbol>, NilClass] the columns to output, nil means all columns (default: nil)
    # @return [String] CSV-string representation.
    # rubocop:enable Metrics/LineLength
    def to_csv(columns: nil)
      attributes = members
      attributes = columns & attributes if columns

      row = attributes.map! { |column| to_csv_value(column) }

      ::CSV.generate_line(row)
    end

    # Describe the contents of this row in a string.
    # @return [String] content of this row
    def inspect
      attributes = members.map do |field|
        value = self[field]
        value = "\"#{value}\"" if value.is_a?(String)

        [field, value].join('=')
      end.join(', ')

      "#<Row #{attributes}>"
    end
    alias_method :to_s, :inspect

    private

    # Returns the column in CSV format
    # @param [Symbol] column name
    # @return [String] column value as CSV string
    def to_csv_value(column)
      value = public_send(column)
      return if value.nil?
      return value.to_csv if value.respond_to?(:to_csv)

      value.to_s
    end
  end
end
