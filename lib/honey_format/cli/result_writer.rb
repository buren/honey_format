module HoneyFormat
  module CLI
    # CLI result writer handles command output
    class ResultWriter
      attr_accessor :verbose

      # Instantiate the result writer
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
      # @param [true, false] verbose mode (default: false)
      def print(string, verbose: false)
        return if !verbose? && verbose

        Kernel.print(string)
      end

      # Puts the string
      # @param [String] string to puts
      # @param [true, false] verbose mode (default: false)
      def puts(string, verbose: false)
        return if !verbose? && verbose

        Kernel.puts(string)
      end
    end
  end
end
