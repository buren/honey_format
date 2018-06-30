# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email,,,country
  john@example.com,John Doe,42,SE
  jane@example.com,Jane Doe,42,DK
CSV

puts '== EXAMPLE: CSV header error =='
puts
bad_converter = proc {}
csv = nil
begin
  csv = HoneyFormat::CSV.new(csv_string, header_converter: bad_converter)
rescue HoneyFormat::HeaderError
  puts 'there was a problem with the header converter, trying with default converter'
  csv = HoneyFormat::CSV.new(csv_string)
end

puts '== CSV START =='
puts csv.to_csv
puts '== CSV END =='
