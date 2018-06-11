require 'honey_format/version'
require 'honey_format/errors'
require 'honey_format/value_converter'
require 'honey_format/csv'


# Main module for HoneyFormat
module HoneyFormat
  # CSV alias
  HoneyCSV = CSV

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  def self.config
    configure
  end

  class Configuration
    attr_reader :converter

    def initialize
      @converter = ValueConverter.new
    end
  end
end
