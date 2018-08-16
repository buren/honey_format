# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email,name,born,country
  john@example.com,John,2000-03-03,SE
  jane@example.com,Jane,1970-03-03,SE
  chris@example.com,Chris,1980-03-03,DK
CSV

puts '== EXAMPLE: CSV output with filtered columns and rows =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string, type_map: { born: :date })
csv_string = csv.to_csv(columns: %i[born country]) do |row|
  row.country == 'SE' && row.born < Date.new(1990, 1, 1)
end
puts csv_string
puts '== CSV END =='
