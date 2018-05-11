require 'honey_format/convert_header_value'

module HoneyFormat
  # Represents a header
  class Header
    include Enumerable

    # @return [Columns] a new instance of Columns.
    # @param [Array] header array of strings.
    # @param [Array] valid array of symbols representing valid columns.
    # @raise [MissingCSVHeaderColumnError] raised when header is missing
    # @raise [UnknownCSVHeaderColumnError] raised when column is not in valid list.
    def initialize(header, valid: :all, converter: ConvertHeaderValue)
      if header.nil? || header.empty?
        fail(MissingCSVHeaderError, "CSV header can't be empty.")
      end

      @original_header = Sanitize.array(header)
      @converter = converter
      @columns = build_columns(@original_header, valid)
    end

    # @return [Array<String>] the original header
    def original
      @original_header
    end

    # @yield [row] The given block will be passed for every column.
    # @yieldparam [Row] a colmn in the CSV header.
    # @return [Enumerator]
    #   If no block is given, an enumerator object will be returned.
    def each(&block)
      @columns.each(&block)
    end

    # Returns columns as array.
    # @return [Array<Symbol>] of columns.
    def to_a
      @columns
    end

    # @return [String] CSV-string representation.
    def to_csv
      @columns.to_csv
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
