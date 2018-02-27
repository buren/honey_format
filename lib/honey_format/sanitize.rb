module HoneyFormat
  # Utility class for sanitizing various simple data types.
  class Sanitize
    # Returns array of cleaned strings.
    # @return [Array<String>] the cleaned array of strings.
    # @param [Array<String>] row the array of strings to be cleaned.
    # @example Sanitize array
    #     Sanitize.array!(["  a "]) #=> ["a"]
    def self.array!(row)
      row.map! { |column| string!(column) }
      row
    end

    # Returns array of cleaned elements.
    # @return [String] the cleaned array.
    # @param [String] column the string to be cleaned.
    # @example Sanitize string
    #     Sanitize.string!("  a ") #=> "a"
    # @example Sanitize nil
    #     Sanitize.string!(nil) #=> nil
    def self.string!(column)
      column.strip! unless column.nil?
      column
    end
  end
end
