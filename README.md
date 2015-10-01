# HoneyFormat [![Build Status](https://travis-ci.org/buren/honey_format.svg)](https://travis-ci.org/buren/honey_format)

Convert CSV to object with one command.

```ruby
csv_string = "Id, Username\n 1, buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.header      # => ["Id", "Username"]
user = csv.rows # => [#<struct id="1", username="buren">]
user.id         # => "1"
user.username   # => "buren"
```

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

include HoneyFormat
# If included you can use the HoneyCSV shorthand
csv = HoneyCSV.new(csv_string)
user = csv.rows # => [#<struct id="1", username="buren">]
user.id         # => "1"
user.username   # => "buren"
```

Validate CSV header
```ruby
csv_string = "Id, Username\n 1, buren"
# Invalid
HoneyCSV.new(csv_string, valid_columns: [:something, :username])
# => #<HoneyFormat::CSVHeaderColumnError: key :id ("Id") not in [:something, :username]>
# Valid
csv = HoneyCSV.new(csv_string, valid_columns: [:id, :username])
csv.rows.first.username # => "buren"
```

Define header
```ruby
csv_string = "1, buren"
csv = HoneyCSV.new(csv_string, header: ['Id', 'Username'])
csv.rows.first.username # => "buren"
```

_Note_: This gem, as you can imagine, adds some overhead to parsing a CSV string. Make sure to benchmark before using this for something performance sensitive.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/honey_format. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
