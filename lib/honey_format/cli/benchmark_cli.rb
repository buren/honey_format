require 'optparse'
require 'honey_format/cli/result_writer'

module HoneyFormat
  # Benchmark CLI
  class BenchmarkCLI
    # CSV default test data location
    CSV_TEST_DATA_URL = 'https://gist.github.com/buren/b669dd82fa37e37672da2cab33c8a830/raw/54ba14a698941ff61f3b854b66df0a7782c79c85/csv_1000_rows.csv'
    # CSV default test data cache location
    CSV_TEST_DATA_CACHE_PATH = '/tmp/honey-format-benchmark-test.csv'

    attr_reader :writer, :options

    # Instantiate the CLI
    def initialize(writer: CLIResultWriter.new)
      @used_input_path = nil
      @writer = writer
      @options = parse_options(argv: ARGV)
      writer.verbose = true if @options[:verbose]
    end

    # Returns the expected runtime in seconds
    # report_count [Integer] number of reports in benchmark
    # @return [Integer] expected runtime in seconds
    def expected_runtime_seconds(report_count:)
      runs = report_count * options[:lines_multipliers].length
      warmup_time_seconds = runs * options[:benchmark_warmup]
      bench_time_seconds = runs * options[:benchmark_time]

      warmup_time_seconds + bench_time_seconds
    end

    # Return the input path used for the benchmark
    # @return [String] the input path (URL or filepath)
    def used_input_path
      options[:input_path] || @used_input_path
    end

    # Download or fetch the default benchmark file from cache
    def fetch_default_benchmark_csv
      cache_path = CSV_TEST_DATA_CACHE_PATH

      if File.exists?(cache_path)
        writer.puts "Cache file found at #{cache_path}.", verbose: true
        @used_input_path = cache_path
        return File.read(cache_path)
      end

      writer.print 'Downloading test data file from GitHub..', verbose: true
      require 'open-uri'
      open(CSV_TEST_DATA_URL).read.tap do |csv|
        @used_input_path = CSV_TEST_DATA_URL
        writer.puts 'done!', verbose: true
        File.write(cache_path, csv)
        writer.puts "Wrote cache file to #{cache_path}..", verbose: true
      end
    end

    # Parse command line arguments and return options
    # @param [Array<String>] argv the command lines arguments
    # @return [Hash] the command line options
    def parse_options(argv:)
      input_path = nil
      benchmark_time = 30
      benchmark_warmup = 5
      lines_multipliers = [1]
      verbose = false

      OptionParser.new do |parser|
        parser.banner = "Usage: bin/benchmark [file.csv] [options]"
        parser.default_argv = ARGV

        parser.on("--csv=[file1.csv]", String, "CSV file(s)") do |value|
          input_path = value
        end

        parser.on("--[no-]verbose", "Verbose output") do |value|
          verbose = value
        end

        parser.on("--lines-multipliers=[1,10,50]", Array, "Multiply the rows in the CSV file (default: 1)") do |value|
          lines_multipliers = value.map do |v|
            Integer(v).tap do |int|
              unless int >= 1
                raise(ArgumentError, '--lines-multiplier must be 1 or greater')
              end
            end
          end
        end

        parser.on("--time=[30]", String, "Benchmark time (default: 30)") do |value|
          benchmark_time = Integer(value)
        end

        parser.on("--warmup=[30]", String, "Benchmark warmup (default: 30)") do |value|
          benchmark_warmup = Integer(value)
        end

        parser.on("-h", "--help", "How to use") do
          puts parser
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
        benchmark_time: benchmark_time,
        benchmark_warmup: benchmark_warmup,
        lines_multipliers: lines_multipliers,
        verbose: verbose,
      }
    end
  end
end
