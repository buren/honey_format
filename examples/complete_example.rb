# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email;name;age;country
  john@example.com;John Doe;42;SE
  jane@example.com;Eric Doe;73;SE
  jane@example.com;Jane Doe;84;DK
  # comment
  pete@example.com;Pete Doe;42;UK
CSV

HoneyFormat.configure do |config|
  config.converter.register(:upcased, proc { |v| v.upcase })
  config.converter.register(:country, proc { |v| v == 'SE' ? 'SWEDEN' : v })
end

puts '== EXAMPLE: CSV complete example =='
puts
header_converter = proc { |v| v == 'email' ? :email_address : v.to_sym }
builder = proc { |row| row.tap { |r| r.age = Integer(r.age) } }
type_map = {
  name: :upcase,
  country: :country,
  email_address: :hex,
  age: :integer
}

begin
  csv = HoneyFormat::CSV.new(
    csv_string,
    type_map: type_map,
    delimiter: ';',
    skip_lines: '#',
    row_builder: builder,
    header_converter: header_converter
  )
  puts '== CSV START =='
  output_columns = %i[email_address country age]
  csv_string = csv.to_csv(columns: output_columns) do |row|
    row.country == 'SWEDEN' # select rows for output
  end
  puts csv_string
  puts '== CSV END =='
rescue HoneyFormat::HeaderError => e
  puts '== ERROR: there was a problem with the header =='
  raise(e)
rescue HoneyFormat::RowError => e
  puts '== ERROR: there was a problem with a row =='
  raise(e)
end
