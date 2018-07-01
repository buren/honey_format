# frozen_string_literal: true

module HoneyFormat
  module Helpers
    # Converts a Hash with key => count to a deduplicated array.
    # @param [Hash] data with key => count
    # @return [Array<Symbol>] an array of symbols
    # @example
    #   Helpers.key_count_to_deduplicated_array({ a: 2, b: 1, c: 0})
    #   # => [:a, :a1, :b]
    def self.key_count_to_deduplicated_array(data)
      array = []
      count_occurences(data).each do |key, value|
        next array << key if value == 1

        values = Array.new(value) { |i| i }.map do |index|
          next key if index.zero?
          :"#{key}#{index}"
        end
        array.concat(values)
      end
      array
    end

    # Returns hash with key => occurrences_count
    # @param [Array<Object>] the array to count occurrences in
    # @return [Hash] key => occurrences_count
    def self.count_occurences(array)
      occurrences = Hash.new(0)
      array.each { |column| occurrences[column] += 1 }
      occurrences
    end

    # Returns array with duplicated objects
    # @param [Array<Object>] the array to find duplicates in
    # @return [Array<Object>] array of duplicated objects
    def self.duplicated_items(array)
      array.select { |col| array.count(col) > 1 }.uniq
    end
  end
end
