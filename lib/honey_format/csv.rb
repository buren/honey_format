require 'csv'

require 'honey_format/row'

module HoneyFormat
  class CSVError < StandardError; end
  class MissingCSVHeaderError       < CSVError; end
  class MissingCSVHeaderColumnError < CSVError; end
  class InvalidCSVHeaderColumnError < CSVError; end
  class InvalidCSVRowLengthError    < CSVError; end

  class CSV
    attr_reader :header, :columns

    def initialize(csv, delimiter: ',', header: nil, valid_columns: :all)
      csv = ::CSV.parse(csv, col_sep: delimiter)
      @head = build_header(header || csv.shift)
      @csv_body = csv
      @columns = build_columns(@head, valid_columns)
      @row_builder = Row.new(@columns)
    end

    def header
      @head
    end

    def rows
      @rows ||= @csv_body.map do |row|
        validate_row!(row)
        @row_builder.build(clean_row(row))
      end
    end

    def row_count
      rows.length
    end

    private

    def build_header(header)
      header || fail(MissingCSVHeaderError, "CSV header can't be empty.")
      clean_row(header)
    end

    def build_columns(keys, valid_columns)
      columns = keys.map do |raw_col|
        raw_col || fail(MissingCSVHeaderColumnError, "CSV header column can't be empty.")
        col = raw_col.downcase.gsub(/ /, '').to_sym
        validate_column!(raw_col, col, valid_columns)
        col
      end
    end

    def clean_row(row)
      row.map { |column| clean(column) }
    end

    def clean(column)
      column.strip unless column.nil?
    end

    def validate_row!(row)
      row.length == header.length ||
        begin
          err_msg = "Invalid row. Row length is #{row.length} and header length #{header.length} for row #{row}"
          fail(InvalidCSVRowLengthError, err_msg)
        end
    end

    def validate_column!(raw_col, col, valid_columns)
      return if valid_columns == :all

      valid_columns.include?(col) ||
        begin
          err_msg = "column :#{col} (\"#{raw_col}\") not in #{valid_columns.inspect}"
          fail(InvalidCSVHeaderColumnError, err_msg)
        end
    end
  end
end
