module HoneyFormat
  class Columns
    include Enumerable

    attr_reader :header

    def initialize(header, valid: :all)
      @header = build_header(header)
      @columns = build_columns(@header, valid)
    end

    def each
      @columns.each { |column| yield(column) }
    end

    private

    def build_header(header)
      if header.nil? || header.empty?
        fail(MissingCSVHeaderError, "CSV header can't be empty.")
      end
      Clean.row(header)
    end

    def build_columns(keys, valid_columns)
      keys.map do |raw|
        raw_col = Clean.column(raw)
        validate_column_presence!(raw_col)

        col = raw_col.downcase.gsub(/ /, '').to_sym

        validate_column_name!(raw_col, col, valid_columns)
        col
      end
    end

    def validate_column_presence!(col)
      if col.nil? || col.empty?
        fail(MissingCSVHeaderColumnError, "CSV header column can't be empty.")
      end
    end

    def validate_column_name!(raw_col, col, valid_columns)
      return if valid_columns == :all

      valid_columns.include?(col) ||
        begin
          err_msg = "column :#{col} (\"#{raw_col}\") not in #{valid_columns.inspect}"
          fail(InvalidCSVHeaderColumnError, err_msg)
        end
    end
  end
end
