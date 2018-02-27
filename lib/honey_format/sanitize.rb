module HoneyFormat
  # Utility class for sanitizing various simple data types.
  class Sanitize
    # Returns array of cleaned strings.
    # @return [Array<String>] the cleaned array of strings.
    # @param [Array<String>] row the array of strings to be cleaned.
    # @example Sanitize array
    #     Sanitize.array(["  a "]) #=> ["a"]
    def self.array(row)
      row.map { |column| string(column) }
    end

    # Returns array of cleaned elements.
    # @return [String] the cleaned array.
    # @param [String] column the string to be cleaned.
    # @example Sanitize string
    #     Sanitize.string("  a ") #=> "a"
    # @example Sanitize nil
    #     Sanitize.string(nil) #=> nil
    def self.string(column)
      return column if column.nil?
      column.strip
    end

    # Returns mutated array of cleaned strings.
    # @return [Array<String>] the cleaned array of strings.
    # @param [Array<String>] row the array of strings to be cleaned.
    # @example Sanitize array
    #     Sanitize.array!(["  a "]) #=> ["a"]
    def self.array!(row)
      row.map! { |column| string!(column) }
    end

    # Returns mutated and cleaned string.
    # @return [String] the cleaned array.
    # @param [String] column the string to be cleaned.
    # @example Sanitize string
    #     Sanitize.string!("  a ") #=> "a"
    # @example Sanitize nil
    #     Sanitize.string!(nil) #=> nil
    def self.string!(column)
      return if column.nil?
      column.tap(&:strip!)
    end
  end
end
