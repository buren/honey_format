module HoneyFormat
  # Header column converter
  module ConvertHeaderValue
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
    # @example Convert simple header
    #     ConvertHeaderValue.call("  User name ") #=> "user_name"
    # @example Convert complex header
    #     ConvertHeaderValue.call(" First name (user)") #=> :'first_name(user)'
    def self.call(column)
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
