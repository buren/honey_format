require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
name,age,country
John Doe,42,SE
CSV

HoneyFormat.configure do |config|
  config.coercer.register :upcased, proc { |v| v.upcase }
  config.coercer.register :country, proc { |v| v == 'SE' ? 'SWEDEN' : v }
end

type_map = {
  name: :upcased,
  country: :country,
}

puts '== EXAMPLE: Upcase name & convert country =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
puts csv.to_csv
puts '== CSV END =='
