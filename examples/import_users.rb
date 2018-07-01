# frozen_string_literal: true

require 'bundler/setup'
require 'honey_format'

csv_string = <<~CSV
  Email,Name,Age,Country
  john@example.com,John Doe,42,Sweden
  jane@example.com,Jane Doe,42,Denmark
CSV

puts '== EXAMPLE: CSV output with filtered columns and rows =='
puts

class User
  def self.create!(attributes)
    puts "Creating user with attributes: #{attributes}"
  end
end

# Map country names to country code
country_coder = lambda do |value|
  {
    'Sweden' => 'SE',
    'Denmark' => 'DK',
    # ...
  }.fetch(value, value)
end

HoneyFormat.configure do |config|
  # Register the country coder
  config.converter.register :country_code, country_coder
end

# Convert the country header column to country_code
header_converter = lambda do |value, index|
  # First use the default converter
  value = HoneyFormat.header_converter.call(value, index)
  value == :country ? :country_code : value
end

# convert column values
type_map = {
  age: :integer,
  country_code: :country_code,
}

csv = HoneyFormat::CSV.new(
  csv_string,
  type_map: type_map,
  header_converter: header_converter
)
csv.each_row { |user| User.create!(user.to_h) }
