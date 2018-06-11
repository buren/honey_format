require 'bundler/setup'
require 'honey_format'
require 'securerandom'

csv_string = <<~CSV
email,name,age,country,payment_id
john@example.com,John Doe,42,SE,3912
john@example.com,John Doe,42,SE,4102
CSV

puts '== EXAMPLE: Anonymize by removing columns from output =='
puts
puts '== CSV START =='
csv = HoneyFormat::CSV.new(csv_string)
puts csv.to_csv(columns: %i[age country])
puts '== CSV END =='
puts
puts
puts '== EXAMPLE: Anonymize by anonymizing the data using a custom row builder =='
puts
class Anonymizer
  def call(row)
    @cache ||= {}
    # Return an object you want to represent the row
    row.tap do |r|
      # given the same value make sure to return the same anonymized value
      @cache[r.email] ||= "#{SecureRandom.hex(2)}@example.com"
      @cache[r.payment_id] ||= SecureRandom.hex(2)
      # update values
      r.email = @cache[r.email]
      r.payment_id = @cache[r.payment_id]
    end
  end
end

csv_string = <<~CSV
Email,Payment ID
buren@example.com,123
buren@example.com,998
jacob@example.com,3211
CSV
csv = HoneyFormat::CSV.new(csv_string, row_builder: Anonymizer.new)
puts '== CSV START =='
puts csv.rows.to_csv
puts '== CSV END =='
