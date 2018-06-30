require 'optparse'

module HoneyFormat
  # Main CLI
  # @attr_reader [Hash] options from command line arguments
  class CLI
    attr_reader :options

    # Instantiate the CLI
    # @return [CLI] the CLI
    def initialize(argv: ARGV, io: STDOUT)
      @io = io
      @options = parse_options(argv: argv.dup)
    end

    private

    def puts(*args)
      @io.puts(*args)
    end

    # Parse command line arguments and return options
    # @param [Array<String>] argv the command lines arguments
    # @return [Hash] the command line options
    def parse_options(argv:)
      input_path = nil
      columns = nil
      output_path = nil
      delimiter = ','
      header_only = false
      rows_only = false

      OptionParser.new do |parser|
        parser.banner = "Usage: honey_format [options] <file.csv>"
        parser.default_argv = argv

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
      end.parse!

      if header_only && rows_only
        raise(ArgumentError, "you can't provide both --header-only and --rows-only")
      end

      if input_path && argv.last
        raise(ArgumentError, "you can't provide both --csv and <path>")
      end
      input_path ||= argv.last

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
