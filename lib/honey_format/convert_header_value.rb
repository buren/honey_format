module HoneyFormat
  module ConvertHeaderValue
    REPLACE_MAP = [
      [/ \(/, '('],
      [/ \[/, '['],
      [/ \{/, '{'],
      [/ /, '_'],
      [/-/, '_']
    ].map { |array| array.freeze }.freeze

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
