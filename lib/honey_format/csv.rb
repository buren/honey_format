# frozen_string_literal: true

require 'csv'
require 'honey_format/matrix'

module HoneyFormat
  # Represents CSV.
  class CSV < Matrix
    # Instantiate CSV.
    # @return [CSV] a new instance of CSV.
    # @param [String] csv the CSV string
    # @param delimiter [String] the CSV column delimiter
    # @param row_delimiter [String, Symbol] the CSV row delimiter (default: :auto)
    # @param quote_character [String] the CSV quote character (default: ")
    # @param header [Array<String>]
    #   header optional argument that represents CSV header, required if the CSV file
    #   lacks a header row.
    # @param header_converter [#call] converts header columns.
    # @param header_deduplicator [#call] deduplicates header columns.
    # @param row_builder [#call] will be called for each parsed row.
    # @param type_map [Hash] map of column_name => type conversion to perform.
    # @param skip_lines [Regexp, String]
    #   Regexp for determining wheter a line is a comment. See CSV skip_lines option.
    # @raise [HeaderError] super class of errors raised when there is a CSV header error.
    # @raise [MissingHeaderError] raised when header is missing (empty or nil).
    # @raise [MissingHeaderColumnError] raised when header column is missing.
    # @raise [RowError] super class of errors raised when there is a row error.
    # @raise [EmptyRowColumnsError] raised when row columns are empty.
    # @raise [InvalidRowLengthError] raised when row has more columns than header columns.
    # @example
    #   csv = HoneyFormat::CSV.new(csv_string)
    # @example With custom delimiter
    #   csv = HoneyFormat::CSV.new(csv_string, delimiter: ';')
    # @example With custom header converter
    #   converter = proc { |v| v == 'name' ? 'first_name' : v }
    #   csv = HoneyFormat::CSV.new("name,id", header_converter: converter)
    #   csv.columns # => [:first_name, :id]
    # @example Handle errors
    #   begin
    #     csv = HoneyFormat::CSV.new(csv_string)
    #   rescue HoneyFormat::HeaderError => e
    #     puts "header error: #{e.class}, #{e.message}"
    #   rescue HoneyFormat::RowError => e
    #     puts "row error: #{e.class}, #{e.message}"
    #   end
    # @see Matrix#new
    def initialize(
      csv,
      delimiter: ',',
      row_delimiter: :auto,
      quote_character: '"',
      header: nil,
      header_converter: HoneyFormat.header_converter,
      header_deduplicator: HoneyFormat.config.header_deduplicator,
      row_builder: nil,
      type_map: {},
      skip_lines: nil
    )
      csv = ::CSV.parse(
        csv,
        col_sep: delimiter,
        row_sep: row_delimiter,
        quote_char: quote_character,
        skip_blanks: true,
        skip_lines: skip_lines
      )
      super(
        csv,
        header: header,
        header_converter: header_converter,
        header_deduplicator: header_deduplicator,
        row_builder: row_builder,
        type_map: type_map
      )
    end
  end
end
