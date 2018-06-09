require 'honey_format/convert_header_value'

module HoneyFormat
  # Represents a header
  class Header
    include Enumerable

    # Instantiate a Header
    # @return [Header] a new instance of Header.
    # @param [Array<String>] header array of strings.
    # @param [Array<Symbol>] valid array of symbols representing valid columns if empty all columns will be considered valid.
    # @param converter [#call] header converter that implements a #call method that takes one column (string) argument.
    # @raise [MissingCSVHeaderColumnError] raised when header is missing
    # @raise [UnknownCSVHeaderColumnError] raised when column is not in valid list.
    # @example Instantiate a header with a customer converter
    #     converter = ->(col) { col == 'username' ? 'handle' : col }
    #     header = HoneyFormat::Header.new(['name', 'username'], converter: converter)
    #     header.to_a # => ['name', 'handle']
    def initialize(header, valid: [], converter: ConvertHeaderValue)
      if header.nil? || header.empty?
        raise(MissingCSVHeaderError, "CSV header can't be empty.")
      end

      @original_header = header
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

    # Return the number of header columns
    # @return [Integer] the number of header columns
    def length
      @columns.length
    end
    alias_method :size, :length

    # Header as CSV-string
    # @return [String] CSV-string representation.
    def to_csv(columns: nil)
      attributes = @columns
      attributes = attributes & columns if columns

      ::CSV.generate_line(attributes)
    end

    private

    # Convert original header
    # @param [Array<String>] header the original header
    # @param [Array<Symbol>] valid list of valid column names if empty all are considered valid.
    # @return [Array<String>] converted columns
    def build_columns(header, valid)
      valid = valid.map(&:to_sym)

      header.each_with_index.map do |column, index|
        column = convert_column(column, index)

        if valid.any? && !valid.include?(column)
          err_msg = "column :#{column} not in #{valid.inspect}"
          raise(UnknownCSVHeaderColumnError, err_msg)
        end

        column
      end
    end

    def convert_column(column, index)
      return @converter.call(column) if converter_arity == 1
      @converter.call(column, index)
    end

    def converter_arity
      # procs and lambdas respond to #arity
      return @converter.arity if @converter.respond_to?(:arity)
      @converter.method(:call).arity
    end
  end
end
