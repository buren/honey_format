require 'honey_format/convert_header_value'

module HoneyFormat
  # Represents a header
  class Header
    include Enumerable

    # Instantiate a Header
    # @return [Header] a new instance of Header.
    # @param [Array<String>] header array of strings.
    # @param [Array<Symbol, String>] valid array representing the valid columns, if empty all columns will be considered valid.
    # @param converter [#call] header converter that implements a #call method that takes one column (string) argument.
    # @raise [HeaderError] super class of errors raised when there is a CSV header error.
    # @raise [MissingHeaderColumnError] raised when header is missing
    # @raise [UnknownHeaderColumnError] raised when column is not in valid list.
    # @example Instantiate a header with a customer converter
    #     converter = ->(col) { col == 'username' ? 'handle' : col }
    #     header = HoneyFormat::Header.new(['name', 'username'], converter: converter)
    #     header.to_a # => ['name', 'handle']
    def initialize(header, valid: [], converter: ConvertHeaderValue)
      if header.nil? || header.empty?
        raise(Errors::MissingHeaderError, "CSV header can't be empty.")
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
    # @yieldparam [Row] a column in the CSV header.
    # @return [Enumerator]
    #   If no block is given, an enumerator object will be returned.
    def each(&block)
      columns.each(&block)
    end

    # Returns columns as array.
    # @return [Array<Symbol>] of columns.
    def columns
      @columns
    end

    # Returns columns as array.
    # @return [Array<Symbol>] of columns.
    def to_a
      columns
    end

    # Return the number of header columns
    # @return [Integer] the number of header columns
    def length
      columns.length
    end
    alias_method :size, :length

    # Header as CSV-string
    # @return [String] CSV-string representation.
    def to_csv(columns: nil)
      attributes = if columns
                     self.columns & columns.map(&:to_sym)
                   else
                     self.columns
                   end

      ::CSV.generate_line(attributes)
    end

    private

    # Convert original header
    # @param [Array<String>] header the original header
    # @return [Array<String>] converted columns
    def build_columns(header, valid)
      valid = valid.map(&:to_sym)

      header.each_with_index.map do |header_column, index|
        convert_column(header_column, index).tap do |column|
          maybe_raise_missing_column!(column)
          maybe_raise_unknown_column!(column, valid)
        end
      end
    end

    # Convert the column value
    # @param [String, Symbol] column the CSV header column value
    # @param [Integer] index the CSV header column index
    # @return [Symbol] the converted column
    def convert_column(column, index)
      value = if converter_arity == 1
                @converter.call(column)
              else
                @converter.call(column, index)
              end
      value.to_sym
    end

    # Returns the converter#call method arity
    # @return [Integer] the converter#call method arity
    def converter_arity
      # procs and lambdas respond to #arity
      return @converter.arity if @converter.respond_to?(:arity)
      @converter.method(:call).arity
    end

    # Raises an error if header column is unknown
    # @param [Object] column the CSV header column
    # @param [Array<Symbol, String>] valid CSV columns
    # @raise [Errors::UnknownHeaderColumnError]
    def maybe_raise_unknown_column!(column, valid)
      return if valid.empty?
      return if valid.include?(column)

      err_msg = "column :#{column} not in #{valid.inspect}"
      raise(Errors::UnknownHeaderColumnError, err_msg)
    end

    # Raises an error if header column is missing/empty
    # @param [Object] column the CSV header column
    # @raise [Errors::MissingHeaderColumnError]
    def maybe_raise_missing_column!(column)
      return if column && !column.empty?

      parts = [
        "CSV header column can't be nil or empty!",
        "When you pass your own converter make sure that it never returns nil or an empty string.",
        'Instead generate unique columns names.'
      ]
      raise(Errors::MissingHeaderColumnError, parts.join(' '))
    end
  end
end
