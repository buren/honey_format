# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'
require 'date'

csv_string = <<~CSV
  email,username,name,age,country,created_date
  john@example.com,  john ,John Doe,42,SE,2015-03-01
  jane@example.com, Jane,Jane Doe,42,DK,2016-04-20
  john1@example.com,John1 ,John Doe,42,NO,2018-01-01
  jane1@example.com,  Jane1,Jane Doe,42,SE,1999-01-01
CSV

country_code_converter = proc { |v|
  {
    'SE' => 'Sweden',
    'DK' => 'Denmark',
    'NO' => 'Norway',
    # ...
  }.fetch(v, v)
}

puts '== EXAMPLE: CSV output with filtered columns and rows =='
puts
puts 'The type converters available by default are:'
puts "    #{HoneyFormat.converter_registry.types.join(', ')}"
puts

HoneyFormat.configure do |config|
  config.converter_registry.register(:country_code, country_code_converter)
end

# Map columns to types
type_map = {
  email: proc { |email| email.downcase }, # pass any object that respond to #call
  age: :integer!, # the ! version will raise an exception if the value can't be converted
  username: [:strip, :downcase, proc { |v| "rE-#{v}" }], # pass an array of converters
  country: :country_code,
  created_date: :date,
}
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)

y2k_date = Date.new(2000, 1, 1)

puts 'Print only records with created_date after 2000-01-01:'
csv_string = csv.to_csv do |row|
  row.created_date > y2k_date # Only select records created after 2000-01-01
end
puts '== CSV START =='
puts csv_string
puts '== CSV END =='
