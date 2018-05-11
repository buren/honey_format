# HoneyFormat [![Build Status](https://travis-ci.org/buren/honey_format.svg)](https://travis-ci.org/buren/honey_format) [![Code Climate](https://codeclimate.com/github/buren/honey_format/badges/gpa.svg)](https://codeclimate.com/github/buren/honey_format) ![Docs badge](https://inch-ci.org/github/buren/honey_format.svg?branch=master)

Convert CSV to an array of objects with with ease.

Perfect for small files of test data or small import scripts.

```ruby
csv_string = "Id, Username\n 1, buren"
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
csv_string = "Id, Username\n 1, buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.header # => ["Id", "Username"]
csv.column # => [:id, :username]

rows = csv.rows # => [#<struct id="1", username="buren">]
user = rows.first
user.id         # => "1"
user.username   # => "buren"
```

Custom row builder
```ruby
csv_string = "Id, Username\n 1, buren"
upcase_builder = ->(o) { o.is_a?(String) ? o.upcase : o  }
csv = HoneyFormat::CSV.new(csv_string, row_builder: upcase_builder)
csv.rows # => [#<struct id="1", username="BUREN">]
```

Output CSV
```ruby
csv_string = "Id, Username\n 1, buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.rows.each { |row| row.id = nil }
csv.to_csv # => "Id, Username\n, buren\n"
```

Validate CSV header
```ruby
csv_string = "Id, Username\n 1, buren"
# Invalid
HoneyFormat::CSV.new(csv_string, valid_columns: [:something, :username])
# => #<HoneyFormat::MissingCSVHeaderColumnError: key :id ("Id") not in [:something, :username]>

# Valid
csv = HoneyFormat::CSV.new(csv_string, valid_columns: [:id, :username])
csv.rows.first.username # => "buren"
```

Define header
```ruby
csv_string = "1, buren"
csv = HoneyFormat::CSV.new(csv_string, header: ['Id', 'Username'])
csv.rows.first.username # => "buren"
```

If your header contains special chars and/or chars that can't be part of Ruby method names,
things get a little awkward..
```ruby
csv_string = "ÅÄÖ\nSwedish characters"
user = HoneyFormat::CSV.new(csv_string).rows.first
# Note that these chars aren't "downcased",
# "ÅÄÖ".downcase # => "ÅÄÖ"
user.ÅÄÖ # => "Swedish characters"

csv_string = "First-Name\nJacob"
user = HoneyFormat::CSV.new(csv_string).rows.first
user.public_send(:"first-name") # => "Jacob"
```

If you want to see more usage examples check out the `spec/` directory.

## Benchmark

_Note_: This gem, adds some overhead to parsing a CSV string. I've included some benchmarks below, your mileage may vary..

Benchmarks, using the `benchmark-ips` gem, CSV with 11 columns in MBP 2013 OSX 10.10.

124KB (~1000 lines )

```
Calculating -------------------------------------
          stdlib CSV     6.000  i/100ms
    HoneyFormat::CSV     5.000  i/100ms
-------------------------------------------------
          stdlib CSV     64.236  (± 4.7%) i/s -    642.000
    HoneyFormat::CSV     52.762  (± 5.7%) i/s -    530.000

Comparison:
          stdlib CSV:       64.2 i/s
    HoneyFormat::CSV:       52.8 i/s - 1.22x slower
```

20MB (~180k lines)

```
Comparison:
          stdlib CSV:        0.3 i/s
    HoneyFormat::CSV:        0.3 i/s - 1.26x slower
```

See `bin/benchmark` for details.
Run benchmark: `bin/benchmark`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/honey_format. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
