# frozen_string_literal: true

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
puts csv.to_csv(columns: %i[age country]) { |row| row.country == 'SE' }
puts '== CSV END =='
