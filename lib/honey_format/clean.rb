module HoneyFormat
  class Clean
    def self.row(row)
      row.map { |column| column(column) }
    end

    def self.column(column)
      column.strip unless column.nil?
    end
  end
end
