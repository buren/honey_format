# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email,,,country
  john@example.com,John Doe,42,SE
  jane@example.com,Jane Doe,42,DK
CSV

puts '== EXAMPLE: CSV without header row =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string)
puts csv.to_csv
puts '== CSV END =='
