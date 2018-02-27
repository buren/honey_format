require 'honey_format/convert_header_value'

module HoneyFormat
  # Represents columns.
  class Columns
    # @return [Columns] a new instance of Columns.
    # @param [Array] header array of strings.
    # @param [Array] valid array of symbols representing valid columns.
    # @raise [MissingCSVHeaderColumnError] raised when header is missing
    # @raise [UnknownCSVHeaderColumnError] raised when column is not in valid list.
    def initialize(header, valid: :all, converter: ConvertHeaderValue)
      @converter = converter
      @columns = build_columns(header, valid)
    end

    # Returns columns as array.
    # @return [Array] of columns.
    def to_a
      @columns
    end

    private

    def build_columns(header, valid)
      header.map do |column|
        column = @converter.call(column.dup)
        validate_column_presence!(column)

        validate_column_name!(column, valid)
        column
      end
    end

    def validate_column_presence!(col)
      if col.nil? || col.empty?
        fail(MissingCSVHeaderColumnError, "CSV header column can't be empty.")
      end
    end

    def validate_column_name!(column, valid)
      return if valid == :all

      valid.include?(column) ||
        begin
          err_msg = "column :#{column} not in #{valid.inspect}"
          fail(UnknownCSVHeaderColumnError, err_msg)
        end
    end
  end
end
