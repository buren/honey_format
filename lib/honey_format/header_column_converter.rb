module HoneyFormat
  # Header column converter
  module HeaderColumnConverter
    # Replace map
    REPLACE_MAP = [
      [/ \(/, '('],
      [/ \[/, '['],
      [/ \{/, '{'],
      [/\) /, ')'],
      [/\] /, ']'],
      [/\} /, '}'],
      [/ /, '_'],
      [/-/, '_']
    ].map { |array| array.freeze }.freeze

    # Returns converted value and mutates the argument.
    # @return [Symbol] the cleaned header column.
    # @param [String] column the string to be cleaned.
    # @param [Integer] column index.
    # @example Convert simple header
    #     HeaderColumnConverter.call("  User name ") #=> "user_name"
    # @example Convert complex header
    #     HeaderColumnConverter.call(" First name (user)") #=> :'first_name(user)'
    def self.call(column, index = nil)
      if column.nil? || column.empty?
        raise(ArgumentError, "column and column index can't be blank/nil") unless index
        return :"column#{index}"
      end

      column = column.dup
      column.strip!
      column.downcase!
      REPLACE_MAP.each do |data|
        from, to = data
        column.gsub!(from, to)
      end
      column.to_sym
    end
  end
end
