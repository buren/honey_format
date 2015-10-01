require 'csv'

module HoneyFormat
  class MissingCSVHeaderError < StandardError; end
  class CSVHeaderColumnError < StandardError; end

  class CSV
    attr_reader :header, :columns

    def initialize(csv, header: nil, valid_columns: :all)
      csv = ::CSV.parse(csv)
      @head = build_header(header || csv.shift)
      @csv_body = csv
      @columns = build_columns(@head, valid_columns)
      @struct_klass = Struct.new(*@columns)
    end

    def header
      @head
    end

    def rows
      @rows ||= @csv_body.map { |row| create_object(row) }
    end

    def row_count
      rows.length
    end

    private

    def build_header(head)
      head || fail(MissingCSVHeaderError, 'CSV header must be present.')
      clean_row(head)
    end

    def build_columns(keys, valid_columns)
      columns = keys.map do |raw_col|
        col = raw_col.downcase.gsub(/ /, '').to_sym
        validate_column!(raw_col, col, valid_columns)
        col
      end
    end

    def create_object(row)
      @struct_klass.new(*clean_row(row))
    end

    def clean_row(row)
      row.map { |column| clean(column) }
    end

    def clean(column)
      column.strip unless column.nil?
    end

    def validate_column!(c, col, valid_columns)
      unless valid_columns == :all
        valid_columns.include?(col) || fail(CSVHeaderColumnError, "column :#{col} (\"#{c}\") not in #{valid_columns.inspect}")
      end
    end
  end
end
