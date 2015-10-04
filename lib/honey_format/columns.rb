module HoneyFormat
  class Columns
    include Enumerable

    attr_reader :header

    def initialize(header, valid_columns)
      @header = build_header(header)
      @columns = build_columns(@header, valid_columns)
    end

    def each
      @columns.each { |column| yield(column) }
    end

    def build_header(header)
      header || fail(MissingCSVHeaderError, "CSV header can't be empty.")
      Clean.row(header)
    end

    def build_columns(keys, valid_columns)
      keys.map do |raw_col|
        raw_col || fail(MissingCSVHeaderColumnError, "CSV header column can't be empty.")
        col = raw_col.downcase.gsub(/ /, '').to_sym
        validate_column!(raw_col, col, valid_columns)
        col
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
