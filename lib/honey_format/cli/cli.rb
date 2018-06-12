require 'optparse'

module HoneyFormat
  # Main CLI
  # @attr_reader [Hash] options from command line arguments
  class CLI
    attr_reader :options

    # Instantiate the CLI
    # @return [CLI] the CLI
    def initialize
      @options = parse_options(argv: ARGV)
    end

    # Parse command line arguments and return options
    # @param [Array<String>] argv the command lines arguments
    # @return [Hash] the command line options
    def parse_options(argv:)
      input_path = argv.first
      columns = nil
      output_path = nil
      delimiter = ','
      header_only = false
      rows_only = false

      OptionParser.new do |parser|
        parser.banner = "Usage: honey_format [file.csv] [options]"
        parser.default_argv = ARGV

        parser.on("--csv=input.csv", String, "CSV file") do |value|
          input_path = value
        end

        parser.on("--columns=id,name", Array, "Select columns") do |value|
          columns = value&.map(&:to_sym)
        end

        parser.on("--output=output.csv", String, "CSV output (STDOUT otherwise)") do |value|
          output_path = value
        end

        parser.on("--delimiter=,", String, "CSV delimiter (default: ,)") do |value|
          delimiter = value
        end

        parser.on("--[no-]header-only", "Print only the header") do |value|
          header_only = value
        end

        parser.on("--[no-]rows-only", "Print only the rows") do |value|
          rows_only = value
        end

        parser.on("-h", "--help", "How to use") do
          puts parser
          exit
        end

        parser.on_tail('--version', 'Show version') do
          puts "HoneyFormat version #{HoneyFormat::VERSION}"
          exit
        end

        # No argument, shows at tail. This will print an options summary.
        parser.on_tail("-h", "--help", "Show this message") do
          puts parser
          exit
        end
      end.parse!

      {
        input_path: input_path,
        columns: columns,
        output_path: output_path,
        delimiter: delimiter,
        header_only: header_only,
        rows_only: rows_only,
      }
    end
  end
end
