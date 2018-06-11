require 'honey_format/version'
require 'honey_format/errors'
require 'honey_format/value_converter'
require 'honey_format/csv'


# Main module for HoneyFormat
module HoneyFormat
  # CSV alias
  HoneyCSV = CSV

  # Configure HoneyFormat
  # @yield [configuration] the configuration
  # @yieldparam [Configuration] current configuration
  # @return [Configuration] current configuration
  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  # Returns the current configuration
  # @return [Configuration] current configuration
  def self.config
    configure
  end

  # Returns the configured header converter
  # @return [#call] the current header converter
  def self.header_converter
    config.header_converter
  end

  # Returns the configured value converter
  # @return [#call] the current value converter
  def self.value_converter
    config.converter
  end

  # Holds HoneyFormat configuration
  class Configuration
    attr_accessor :header_converter, :converter

    # Instantiate configuration
    def initialize
      @converter = ValueConverter.new
      @header_converter = ConvertHeaderValue
    end
  end
end
