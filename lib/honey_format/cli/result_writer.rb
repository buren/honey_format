# frozen_string_literal: true

module HoneyFormat
  # CLI result writer handles command output
  # @attr_reader [true, false] verbose the writer mode
  class CLIResultWriter
    attr_accessor :verbose

    # Instantiate the result writer
    # @param verbose [true, false] mode (default: false)
    # @return [CLIResultWriter] the result writer
    def initialize(verbose: false)
      @verbose = verbose
    end

    # Return if verbose mode is true/false
    # @return [true, false]
    def verbose?
      @verbose
    end

    # Print the string
    # @param [String] string to print
    # @param verbose [true, false] mode (default: false)
    def print(string, verbose: false)
      return if !verbose? && verbose

      Kernel.print(string)
    end

    # Puts the string
    # @param [String] string to puts
    # @param verbose [true, false] mode (default: false)
    def puts(string, verbose: false)
      return if !verbose? && verbose

      Kernel.puts(string)
    end
  end
end
