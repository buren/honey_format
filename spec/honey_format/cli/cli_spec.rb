require "spec_helper"
require "honey_format/cli/cli"

RSpec.describe HoneyFormat::CLI do
  describe "#initialize" do
    let(:test_io) do
      Struct.new(:lines) do
        define_method(:puts) { |o| lines << o.to_s }
      end.new([])
    end

    it "raises argument error if --csv and <path> arguments given" do
      argv = ["--csv=input.csv", "input1.csv"]
      message = "you can't provide both --csv and <path>"
      expect { described_class.new(argv: argv) }.to raise_error(ArgumentError, message)
    end

    it "raises argument error if both --header-only and --rows-only arguments are given" do
      argv = ["--header-only", "--rows-only", "input1.csv"]
      message = "you can't provide both --header-only and --rows-only"
      expect { described_class.new(argv: argv) }.to raise_error(ArgumentError, message)
    end

    it "has --version option" do
      argv = ["--version"]
      expect { described_class.new(argv: argv, io: test_io) }.to raise_error(SystemExit)
      expect(test_io.lines.first).to include(HoneyFormat::VERSION)
    end

    it "has -v option" do
      argv = ["-v"]
      expect { described_class.new(argv: argv, io: test_io) }.to raise_error(SystemExit)
      expect(test_io.lines.first).to include(HoneyFormat::VERSION)
    end

    it "has --help option" do
      argv = ["--help"]
      expect { described_class.new(argv: argv, io: test_io) }.to raise_error(SystemExit)
      expect(test_io.lines.first).to include("Usage: honey_format")
    end

    it "has -h option" do
      argv = ["-h"]
      expect { described_class.new(argv: argv, io: test_io) }.to raise_error(SystemExit)
      expect(test_io.lines.first).to include("Usage: honey_format")
    end
  end

  describe "#options" do
    it "works with minimal options" do
      argv = ["input.csv"]
      cli = described_class.new(argv: argv)
      expected = {
        input_path: "input.csv",
        columns: nil,
        output_path: nil,
        delimiter: ",",
        header_only: false,
        rows_only: false,
        type_map: {},
        skip_lines: nil
      }
      expect(cli.options).to eq(expected)
    end

    it "works with csv input path at tail" do
      argv = [
        "--columns=id,name",
        "input.csv",
      ]
      cli = described_class.new(argv: argv)
      expected = {
        input_path: "input.csv",
        columns: %i[id name],
        output_path: nil,
        delimiter: ",",
        header_only: false,
        rows_only: false,
        type_map: {},
        skip_lines: nil
      }
      expect(cli.options).to eq(expected)
    end

    it "works with all options (with --csv flag)" do
      argv = [
        "--csv=input.csv",
        "--columns=id,name",
        "--output=output.csv",
        "--skip-lines=buren",
        "--delimiter=:",
        "--header-only",
        "--no-rows-only",
        "--type-map=id=integer,name=upcase"
      ]
      cli = described_class.new(argv: argv)
      expected = {
        input_path: "input.csv",
        columns: %i[id name],
        output_path: "output.csv",
        delimiter: ":",
        header_only: true,
        rows_only: false,
        type_map: { id: :integer, name: :upcase },
        skip_lines: "buren"
      }
      expect(cli.options).to eq(expected)
    end
  end
end
