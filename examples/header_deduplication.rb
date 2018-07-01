# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  email,email,name
  john@example.com,jane@example.com,John
CSV

puts '== EXAMPLE: CSV with duplicated header columns =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string, header_deduplicator: :deduplicate)
puts csv.to_csv
puts '== CSV END =='
