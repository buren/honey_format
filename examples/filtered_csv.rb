require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
email,name,age,country
john@example.com,John Doe,42,SE
jane@example.com,Jane Doe,42,DK
CSV

puts '== EXAMPLE: CSV output with filtered columns and rows =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv(columns: [:age, :country]) { |row| row.country == 'SE' }.tap do |string|
  puts string
end
puts '== CSV END =='
