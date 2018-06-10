module HoneyFormat
  module CLI
    class ResultWriter
      attr_accessor :verbose

      def initialize(verbose: false)
        @verbose = verbose
      end

      def verbose?
        @verbose
      end

      def print(string, verbose: false)
        return if !verbose? && verbose

        Kernel.print(string)
      end

      def puts(string, verbose: false)
        return if !verbose? && verbose

        Kernel.puts(string)
      end
    end
  end
end
