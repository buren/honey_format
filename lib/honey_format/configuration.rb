# frozen_string_literal: true

module HoneyFormat
  # Holds HoneyFormat configuration
  # @attr_reader [#call] header_converter the configured header converter
  # @attr_reader [#call] converter the configured value converter
  # @attr_writer [#call] header_converter to use
  # @attr_writer [#call] converter the value converter to use
  class Configuration
    attr_accessor :converter
    attr_reader :header_converter

    # Instantiate configuration
    def initialize
      @converter = ValueConverter.new
      @header_converter = @converter[:header_column]
    end

    # Set the header converter
    # @param [Symbol, #call] converter for registered value converter or object that
    #                        responds to #call
    # @return [#call] the header converter
    def header_converter=(converter)
      @header_converter = if converter.is_a?(Symbol)
                            @converter[converter]
                          else
                            converter
                          end
    end
  end
end
