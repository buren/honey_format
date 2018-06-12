module HoneyFormat
  # Holds HoneyFormat configuration
  class Configuration
    attr_accessor :header_converter, :converter

    # Instantiate configuration
    def initialize
      @converter = ValueConverter.new
      @header_converter = @converter[:header_column]
    end

    # Set the header converter
    # @param [Symbol, #call] symbol for registered value converter or object that responds to #call
    # @return [#call] the header converter
    def header_converter=(converter)
      if converter.is_a?(Symbol)
        return @header_converter = @converter[converter]
      end
      @header_converter = converter
    end
  end
end
