# frozen_string_literal: true

require 'honey_format/helpers/helpers'

module HoneyFormat
  # Represents a header
  class Header
    include Enumerable

    # Instantiate a Header
    # @return [Header] a new instance of Header.
    # @param [Array<String>] header array of strings.
    # @param converter [#call, Symbol]
    #   header converter that implements a #call method
    #   that takes one column (string) argument OR symbol for a registered
    #   converter registry.
    # @raise [HeaderError] super class of errors raised when there is a CSV header error.
    # @raise [MissingHeaderColumnError] raised when header is missing
    # @example Instantiate a header with a custom converter
    #     converter = ->(col) { col == 'username' ? 'handle' : col }
    #     header = HoneyFormat::Header.new(['name', 'username'], converter: converter)
    #     header.to_a # => ['name', 'handle']
    def initialize(
      header,
      converter: HoneyFormat.header_converter,
      deduplicator: HoneyFormat.config.deduplicate_header_strategy
    )
      if header.nil? || header.empty?
        raise(Errors::MissingHeaderError, "CSV header can't be empty.")
      end

      @original_header = header
      @deduplicator = deduplicator
      @converter = if converter.is_a?(Symbol)
                     HoneyFormat.converter[converter]
                   else
                     converter
                   end

      @columns = build_columns(@original_header)
    end

    # Returns the original header
    # @return [Array<String>] the original header
    def original
      @original_header
    end

    # Returns true if columns contains no elements.
    # @return [true, false] true if columns contains no elements.
    def empty?
      @columns.empty?
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
    def build_columns(header)
      cache = Hash.new(0)

      columns = header.each_with_index.map do |header_column, index|
        convert_column(header_column, index).tap do |column|
          cache[column] += 1
          maybe_raise_missing_column!(column)
        end
      end

      @deduplicator.call(columns, cache)
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

    # Raises an error if header column is missing/empty
    # @param [Object] column the CSV header column
    # @raise [Errors::MissingHeaderColumnError]
    def maybe_raise_missing_column!(column)
      return if column && !column.empty?

      parts = [
        "CSV header column can't be nil or empty!",
        'When you pass your own converter make sure that it never returns nil or an empty string.', # rubocop:disable Metrics/LineLength
        'Instead generate unique columns names.',
      ]
      raise(Errors::MissingHeaderColumnError, parts.join(' '))
    end
  end
end
