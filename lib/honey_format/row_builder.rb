module HoneyFormat
  # Default row builder
  class RowBuilder < Struct
    # @return [Struct] returns an instantiated Struct representing a row
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
end
