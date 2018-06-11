require 'bundler/setup'
require 'honey_format'

csv_string = "name;id|'John Doe';42"
csv = HoneyFormat::CSV.new(
  csv_string,
  delimiter: ';',
  row_delimiter: '|',
  quote_character: "'",
)

puts '== EXAMPLE: CSV with custom column delimiter, row delimiter and quote character =='
puts
puts '== CSV START =='
puts csv.to_csv
puts '== CSV END =='
