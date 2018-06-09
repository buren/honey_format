# HoneyFormat [![Build Status](https://travis-ci.org/buren/honey_format.svg)](https://travis-ci.org/buren/honey_format) [![Code Climate](https://codeclimate.com/github/buren/honey_format/badges/gpa.svg)](https://codeclimate.com/github/buren/honey_format) ![Docs badge](https://inch-ci.org/github/buren/honey_format.svg?branch=master)

Convert CSV to an array of objects with with ease.

Perfect for small files of test data or small import scripts.

```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.header      # => ["Id", "Username"]
user = csv.rows # => [#<struct id="1", username="buren">]
user.id         # => "1"
user.username   # => "buren"
```

:information_source: Supports Ruby >= 2.3, has no dependencies other than Ruby stdlib.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'honey_format'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install honey_format
```

## Usage

By default assumes a header in the CSV file.

```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.header # => ["Id", "Username"]
csv.columns # => [:id, :username]

rows = csv.rows # => [#<struct id="1", username="buren">]
user = rows.first
user.id         # => "1"
user.username   # => "buren"
```

Minimal custom row builder
```ruby
csv_string = "Id,Username\n1,buren"
upcaser = ->(row) { row.tap { |r| r.username.upcase! } }
csv = HoneyFormat::CSV.new(csv_string, row_builder: upcaser)
csv.rows # => [#<struct id="1", username="BUREN">]
```

Complete custom row builder
```ruby
class Anonymizer
  def self.call(row)
    # Return an object you want to represent the row
    row.tap do |r|
      r.name = '<anon>'
      r.email = '<anon>'
      r.ssn = '<anon>'
      r.payment_id = '<scrubbed>'
    end
  end
end

csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string, row_builder: Anonymizer)
csv.rows # => [#<struct id="1", username="BUREN">]
```

Output CSV
```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.rows.each { |row| row.id = nil }
csv.to_csv # => "id,username\n,buren\n"
```

Output a subset of columns to CSV
```ruby
csv_string = "Id, Username, Country\n1,buren,Sweden"
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv(columns: [:id, :country]) # => "id,country\nburen,Sweden\n"
```

Output a subset of rows to CSV
```ruby
csv_string = "Name, Country\nburen,Sweden\njacob,Denmark"
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv { |row| row.country == 'Sweden' } # => "name,country\nburen,Sweden\n"
```

You can of course set the delimiter
```ruby
HoneyFormat::CSV.new(csv_string, delimiter: ';')
```

Validate CSV header
```ruby
csv_string = "Id,Username\n1,buren"
# Invalid
HoneyFormat::CSV.new(csv_string, valid_columns: [:something, :username])
# => HoneyFormat::UnknownHeaderColumnError (column :id not in [:something, :username])

# Valid
csv = HoneyFormat::CSV.new(csv_string, valid_columns: [:id, :username])
csv.rows.first.username # => "buren"
```

Define header
```ruby
csv_string = "1,buren"
csv = HoneyFormat::CSV.new(csv_string, header: ['Id', 'Username'])
csv.rows.first.username # => "buren"
```

If your header contains special chars and/or chars that can't be part of Ruby method names,
things can get a little awkward..
```ruby
csv_string = "ÅÄÖ\nSwedish characters"
user = HoneyFormat::CSV.new(csv_string).rows.first
# Note that these chars aren't "downcased" in Ruby 2.3 and older versions of Ruby,
# "ÅÄÖ".downcase # => "ÅÄÖ"
user.ÅÄÖ # => "Swedish characters"
# while on Ruby > 2.3
user.åäö

csv_string = "First^Name\nJacob"
user = HoneyFormat::CSV.new(csv_string).rows.first
user.public_send(:"first^name") # => "Jacob"
# or
user['first^name'] # => "Jacob"
```

Pass your own header converter
```ruby
map = { 'First^Name' => :first_name }
converter = ->(column) { map.fetch(column, column) }

csv_string = "First^Name\nJacob"
user = HoneyFormat::CSV.new(csv_string, header_converter: converter).rows.first
user.first_name # => "Jacob"
```

Missing header values
```ruby
csv_string = "first,,third\nval0,val1,val2"
csv = HoneyFormat::CSV.new(csv_string)
user = csv.rows.first
user.column1 # => "val1"
```

Errors
```ruby
# there are two error super classes
begin
  HoneyFormat::CSV.new(csv_string)
rescue HoneyFormat::HeaderError => e
  puts 'there is a problem with the header'
  raise(e)
rescue HoneyFormat::RowError => e
  puts 'there is a problem with a row'
  raise(e)
end
```

You can see all [available errors here](https://www.rubydoc.info/gems/honey_format/HoneyFormat/Errors).

If you want to see more usage examples check out the `spec/` directory.

## Benchmark

_Note_: This gem, adds some overhead to parsing a CSV string. I've included some benchmarks below, your mileage may vary..

You can run the benchmarks yourself:

```
$ bin/benchmark file.csv
```

204KB (1k lines)

```
      stdlib CSV:       51.9 i/s
HoneyFormat::CSV:       49.6 i/s - 1.05x  slower
```

19MB (100k lines)

```
      stdlib CSV:        0.4 i/s
HoneyFormat::CSV:        0.4 i/s - 1.11x  slower
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/honey_format. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
