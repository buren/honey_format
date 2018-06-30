# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email,name,age,country
  john@example.com,John Doe,42,SE
  jane@example.com,Jane Doe,84,DK
  pete@example.com,Pete Doe,42,UK
CSV

puts '== EXAMPLE: CSV complete example =='
puts
header_converter = proc { |v| v == 'email' ? :email_address : v.to_sym }
builder = proc { |row| row.tap { |r| r.age = Integer(r.age) } }
begin
  csv = HoneyFormat::CSV.new(
    csv_string,
    row_builder: builder,
    header_converter: header_converter
  )
  puts '== CSV START =='
  output_columns = %i[email_address country]
  puts csv.to_csv(columns: output_columns) { |row| row.age == 42 }
  puts '== CSV END =='
rescue HoneyFormat::HeaderError => e
  puts '== ERROR: there was a problem with the header =='
  raise(e)
rescue HoneyFormat::RowError => e
  puts '== ERROR: there was a problem with a row =='
  raise(e)
end
