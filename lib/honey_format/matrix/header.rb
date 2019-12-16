# frozen_string_literal: true

require 'honey_format/helpers/helpers'

module HoneyFormat
  # Represents a header
  class Header
    include Enumerable

    # Instantiate a Header
    # @return [Header] a new instance of Header.
    # @param [Array<String>] header array of strings.
    # @param converter [#call, Symbol, Hash]
    #   header converter that implements a #call method
    #   that takes one column (string) argument OR symbol for a registered
    #   converter registry OR a hash mapped to a symbol or something that responds
    #   to #call.
    # @param deduplicator [#call, Symbol]
    #   header deduplicator that implements a #call method
    #   that takes columns Array<String> argument OR symbol for a registered
    #   deduplicator registry.
    # @raise [HeaderError] super class of errors raised when there is a CSV header error.
    # @raise [MissingHeaderColumnError] raised when header is missing
    # @example Instantiate a header with a custom converter
    #     converter = ->(col) { col == 'username' ? 'handle' : col }
    #     header = HoneyFormat::Header.new(['name', 'username'], converter: converter)
    #     header.to_a # => ['name', 'handle']
    def initialize(
      header,
      converter: HoneyFormat.header_converter,
      deduplicator: HoneyFormat.config.header_deduplicator
    )
      if header.nil? || header.empty?
        raise(Errors::MissingHeaderError, "CSV header can't be empty.")
      end

      @original_header = header
      self.deduplicator = deduplicator
      self.converter = converter
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

    # Set the header converter
    # @param [Hash, Symbol, #call] symbol to known converter, object that responds to #call or Hash
    # @return [nil]
    def converter=(object)
      if object.is_a?(Symbol)
        @converter = HoneyFormat.converter_registry[object]
        return
      end

      if object.is_a?(Hash)
        @converter = hash_converter(object)
        return
      end

      @converter = object
    end

    # Set the header deduplicator
    # @param [Symbol, #call] symbol to known deduplicator or object that responds to #call
    # @return [nil]
    def deduplicator=(object)
      if object.is_a?(Symbol)
        @deduplicator = HoneyFormat.header_deduplicator_registry[object]
        return
      end

      @deduplicator = object
    end

    # Convert original header
    # @param [Array<String>] header the original header
    # @return [Array<String>] converted columns
    def build_columns(header)
      columns = header.each_with_index.map do |header_column, index|
        convert_column(header_column, index).tap do |column|
          maybe_raise_missing_column!(column)
        end
      end

      @deduplicator.call(columns)
    end

    # Convert the column value
    # @param [String, Symbol] column the CSV header column value
    # @param [Integer] index the CSV header column index
    # @return [Symbol] the converted column
    def convert_column(column, index)
      call_column_builder(@converter, column, index)&.to_sym
    end

    # Returns the callable object method arity
    # @param [#arity, #call] callable thing that responds to #call and maybe #arity
    # @return [Integer] the method arity
    def callable_arity(callable)
      # procs and lambdas respond to #arity
      return callable.arity if callable.respond_to?(:arity)

      callable.method(:call).arity
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

    def hash_converter(hash)
      lambda { |value, index|
        # support strings and symbol keys interchangeably
        column = hash.fetch(value) do
          key = value.respond_to?(:to_sym) ? value.to_sym : value
          # if column is unmapped use the default header converter
          hash.fetch(key) { HoneyFormat.header_converter.call(value, index) }
        end

        # The hash can contain mixed values, Symbol and procs
        if column.respond_to?(:call)
          column = call_column_builder(column, value, index)
        end

        column&.to_sym
      }
    end

    def call_column_builder(callable, value, index)
      return callable.call if callable_arity(callable).zero?
      return callable.call(value) if callable_arity(callable) == 1
      callable.call(value, index)
    end
  end
end
