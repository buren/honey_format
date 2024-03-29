# HoneyFormat [![Build Status](https://travis-ci.org/buren/honey_format.svg)](https://travis-ci.org/buren/honey_format) [![Code Climate](https://codeclimate.com/github/buren/honey_format/badges/gpa.svg)](https://codeclimate.com/github/buren/honey_format) [![Inline docs](http://inch-ci.org/github/buren/honey_format.svg)](https://www.rubydoc.info/gems/honey_format/)

> Makes working with CSVs as smooth as honey.

Proper objects for CSV headers and rows, convert column values, filter columns and rows, small(-ish) perfomance overhead, no dependencies other than Ruby stdlib.

## Features

- Proper objects for CSV header and rows
- Convert row and header column values
- Pass your own custom row builder
- Filter what columns and rows are included in CSV output
- Gracefully handle missing and duplicated header columns
- [CLI](#cli) - Simple command line interface
- Only ~5-10% overhead from using Ruby CSV, see [benchmarks](#benchmark)
- Has no dependencies other than Ruby stdlib
- Supports Ruby >= 2.3

Read the [usage section](#usage),  [RubyDoc](https://www.rubydoc.info/gems/honey_format/) or [examples/ directory](https://github.com/buren/honey_format/tree/master/examples)  for how to use this gem.

## Quick use

```ruby
csv_string = <<-CSV
Id,Username,Email
1,buren,buren@example.com
2,jacob,jacob@example.com
CSV
csv = HoneyFormat::CSV.new(csv_string, type_map: { id: :integer })
csv.columns     # => [:id, :username, :email]
csv.rows        # => [#<Row id=1, username="buren", email="buren@example.com">, #<Row id=2, username="jacob", email="jacob@example.com">]
user = csv.rows.first
user.id         # => 1
user.username   # => "buren"

csv.to_csv(columns: [:id, :username]) { |row| row.id < 2 }
# => "id,username\n1,buren\n"
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

By default assumes a header in the CSV file

```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)

# Header
header = csv.header
header.original # => ["Id", "Username"]
header.columns  # => [:id, :username]


# Rows
rows = csv.rows # => [#<Row id="1", username="buren">]
user = rows.first
user.id         # => "1"
user.username   # => "buren"
```

Set delimiter & quote character
```ruby
csv_string = "name;id|'John Doe';42"
csv = HoneyFormat::CSV.new(
  csv_string,
  delimiter: ';',
  row_delimiter: '|',
  quote_character: "'",
)
```

__Type converters__

> Type converters are great if you want to convert column values, like numbers and dates.

There are a bunch of [default type converters](https://github.com/buren/honey_format/blob/master/lib/honey_format/converters/converters.rb)
```ruby
csv_string = "Id,Username\n1,buren"
type_map = { id: :integer }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.id # => 1
```

Pass your own
```ruby
csv_string = "Id,Username\n1,buren"
type_map = { username: proc { |v| v.upcase } }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.username # => "BUREN"
```

Combine multiple converters
```ruby
csv_string = "Id,Username\n1,  BuRen  "
type_map = { username: [:strip, :downcase] }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.username # => "buren"
```

Register your own converter
```ruby
HoneyFormat.configure do |config|
  config.converter_registry.register :upcased, proc { |v| v.upcase }
end

csv_string = "Id,Username\n1,buren"
type_map = { username: :upcased }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.username # => "BUREN"
```

Remove registered converter
```ruby
HoneyFormat.configure do |config|
  config.converter_registry.unregister :upcase
  # now you're free to register your own
  config.converter_registry.register :upcase, proc { |v| v.upcase if v }
end
```

Access registered converters
```ruby
decimal_converter = HoneyFormat.converter_registry[:decimal]
decimal_converter.call('1.1') # => 1.1
```

Default converter names
```ruby
HoneyFormat.config.default_converters.keys
```

See [`Converters::DEFAULT`](https://github.com/buren/honey_format/blob/master/lib/honey_format/converters.rb) for a complete list of the default converter names.

__Row builder__

> Pass your own row builder if you want more control of the entire row or if you want to return your own row object.

Custom row builder
```ruby
csv_string = "Id,Username\n1,buren"
upcaser = ->(row) { row.tap { |r| r.username.upcase! } }
csv = HoneyFormat::CSV.new(csv_string, row_builder: upcaser)
csv.rows # => [#<Row id="1", username="BUREN">]
```

As long as the row builder responds to `#call` you can pass anything you like
```ruby
class Anonymizer
  def call(row)
    @cache ||= {}
    # Return an object you want to represent the row
    row.tap do |r|
      # given the same value make sure to return the same anonymized value every time
      @cache[r.email] ||= "#{SecureRandom.hex(6)}@example.com"
      r.email = @cache[r.email]
      r.payment_id = '<scrubbed>'
    end
  end
end

csv_string = <<~CSV
Email,Payment ID
buren@example.com,123
buren@example.com,998
CSV
csv = HoneyFormat::CSV.new(csv_string, row_builder: Anonymizer.new)
csv.rows.to_csv(columns: [:email])
# => 8f6ed70a7f98@example.com
#    8f6ed70a7f98@example.com
#    0db96f350cea@example.com
```

__Output CSV__

> Makes it super easy to output a subset of columns/rows.

Manipulate the rows before output
```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)
csv.rows.each { |row| row.id = nil }
csv.to_csv # => "id,username\n,buren\n"
```

Output a subset of columns
```ruby
csv_string = "Id, Username, Country\n1,buren,Sweden"
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv(columns: [:id, :country]) # => "id,country\nburen,Sweden\n"
```

Output a subset of rows
```ruby
csv_string = "Name, Country\nburen,Sweden\njacob,Denmark"
csv = HoneyFormat::CSV.new(csv_string)
csv.to_csv { |row| row.country == 'Sweden' } # => "name,country\nburen,Sweden\n"
```

__Headers__

> By default generates method-like names for each header column, but also gives you full control: define them or convert them.

By default assumes a header in the CSV file.
```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)

# Header
header = csv.header
header.original # => ["Id", "Username"]
header.columns  # => [:id, :username]
```

Define header
```ruby
csv_string = "1,buren"
csv = HoneyFormat::CSV.new(csv_string, header: ['Id', 'Username'])
csv.rows.first.username # => "buren"
```

Set default header converter
```ruby
HoneyFormat.configure do |config|
  config.header_converter = proc { |v| v.downcase }
end

# you can get the default one with
header_converter = HoneyFormat.converter_registry[:header_column]
header_converter.call('First name') # => "first_name"
```

Use any converter registry as the header converter
```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string, header_converter: :upcase)
csv.columns # => [:ID, :USERNAME]
```

Pass your own header converter
```ruby
# unmapped keys use the default header converter,
# mix simple key => value mapping with key => proc
converter = {
  'First^Name' => :first_name,
  'Username' => -> { :handle }
}

csv_string = "ID,Username,First^Name\n1,buren,Jacob"
user = HoneyFormat::CSV.new(csv_string, header_converter: converter).rows.first
user.first_name # => "Jacob"
user.handle     # => "buren"
user.id         # => "1"

# you can also pass a proc or any callable object
converter = Class.new do
  define_singleton_method(:call) { |value, index| "#{value}#{index}" }
end
# or
converter = ->(value, index) { "#{value}#{index}"  }
user = HoneyFormat::CSV.new(csv_string, header_converter: converter)
```

Missing header values are automatically set and deduplicated
```ruby
csv_string = "first,,third,third\nval0,val1,val2,val3"
csv = HoneyFormat::CSV.new(csv_string)
user = csv.rows.first
user.column1 # => "val1"
user.third   # => "val2"
user.third1  # => "val3"
```

Duplicated header values
```ruby
csv_string = <<~CSV
  email,email,name
  john@example.com,jane@example.com,John
CSV
# :deduplicate is the default value
csv = HoneyFormat::CSV.new(csv_string, header_deduplicator: :deduplicate)
user = csv.rows.first
user.email  # => john@example.com
user.email1 # => jane@example.com

# you can also choose to raise an error instead
HoneyFormat::CSV.new(csv_string, header_deduplicator: :raise)
# => HoneyFormat::DuplicateHeaderColumnError
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

Emoji characters
```ruby
csv_string = "😎⛷\nEmoji characters"
csv = HoneyFormat::CSV.new(csv_string)
csv.rows.first.😎⛷ # => Emoji characters
```

__Errors__

> When you need to be extra safe.

If you want to there are some errors you can rescue
```ruby
begin
  HoneyFormat::CSV.new(csv_string)
rescue HoneyFormat::HeaderError => e
  puts 'there was a problem with the header'
  raise(e)
rescue HoneyFormat::RowError => e
  puts 'there was a problem with a row'
  raise(e)
end
```

You can see all [available errors here](https://www.rubydoc.info/gems/honey_format/HoneyFormat/Errors).

__Skip lines__

> Skip comments and/or other unwanted lines from being parsed.

```ruby
csv_string = <<~CSV
Id,Username
1,buren
# comment
2,jacob
CSV
regexp = %r{\A#} # Match all lines that start with "#"
csv = HoneyFormat::CSV.new(csv_string, skip_lines: regexp)
csv.rows.length # => 2
```

__Matrix__

> Use whats under the hood.

Actually `HoneyFormat::CSV` is a very thin wrapper around `HoneyFormat::Matrix`.
You can use `Matrix` directly it support all options that aren't specifically tied to parsing a CSV.

Example
```ruby
data = [
  %w[name id],
  %w[jacob 1]
]
type_map = {
  id: :integer,
  name: :upcase
}

matrix = HoneyFormat::Matrix.new(data, type_map: { id: :integer, name: :upcase })
matrix.columns   # => [:name, :id]
matrix.rows.to_a # => [#<Row name="JACOB", id=1>]
matrix.to_csv    # => "name,id\nJACOB,1\n"
```

If you want to see more usage examples check out the [`examples/`](https://github.com/buren/honey_format/tree/master/examples) and [`spec/`](https://github.com/buren/honey_format/tree/master/spec) directories and of course [on RubyDoc](https://www.rubydoc.info/gems/honey_format/).


__SQL example__

When you want the result as an object, with certain columns converted to objects.

```ruby
require 'mysql2'

class DBClient
  def initialize(host:, username:, password:, port: 3306)
    @client = Mysql2::Client.new(
      host: host,
      username: username,
      password: password,
      port: port
    )
  end

  def query(sql, type_map: {})
    result = @client.query(sql)
    return if result.first.nil?

    matrix = HoneyFormat::Matrix.new(
      result.map(&:values),
      header: result.first.keys,
      type_map: type_map
    )
    matrix.rows
  end
end
```

Usage example with a fictional "users" database table (schema: `name`, `created_at`)
```ruby
client = DbClient.new(host: '127.0.0.1', username: 'root', password: nil)
users = client.query(
  'SELECT * FROM users',
  type_map: { created_at: :datetime! }
)
user = users.first
user.name # => buren
user.created_at.class # => Time
```

## Configuration

Configuration is optional
```ruby
HoneyFormat.configure do |config|
  config.header_converter = proc { |column| column.downcase }
  config.delimiter = ";"
  config.row_delimiter = "|"
  config.quote_character = "'"
  config.skip_lines = %r{\A#} # Match all lines that start with "#"
end
```

Default configuration values
```ruby
HoneyFormat.configure do |config|
  config.header_converter = HoneyFormat::Registry.new(Converters::DEFAULT)[:header_column]
  config.delimiter = ","
  config.row_delimiter = :auto
  config.quote_character = "\""
  config.skip_lines = nil
end
```

## CLI

> Perfect when you want to get something simple done quickly.

```
Usage: honey_format [options] <file.csv>
        --csv=input.csv              CSV file
        --columns=id,name            Select columns
        --output=output.csv          CSV output (STDOUT otherwise)
        --delimiter=,                CSV delimiter (default: ,)
        --skip-lines=,               Skip lines that match this pattern
        --[no-]header-only           Print only the header
        --[no-]rows-only             Print only the rows
    -h, --help                       How to use
        --version                    Show version
```

Output a subset of columns to a new file
```
# input.csv
id,name,username
1,jacob,buren
```

```
$ honey_format input.csv --columns=id,username > output.csv
```


## Benchmark

_Note_: This gem, adds some overhead to parsing a CSV string, typically ~5-10%. I've included some benchmarks below, your mileage may vary.. The benchmarks have been run with Ruby 2.5.

204KB (1k lines)

```
 CSV no options:       51.0 i/s
 CSV with header:      36.1 i/s - 1.41x  slower
HoneyFormat::CSV:      48.7 i/s - 1.05x  slower
```

2MB (10k lines)

```
  CSV no options:        5.1 i/s
 CSV with header:        3.6 i/s - 1.42x  slower
HoneyFormat::CSV:        4.9 i/s - 1.05x  slower
```

You can run the benchmarks yourself
```
Usage: bin/benchmark [file.csv] [options]
        --csv=[file1.csv]            CSV file(s)
        --[no-]verbose               Verbose output
        --lines-multipliers=[1,2,10] Multiply the rows in the CSV file (default: 1)
        --time=[30]                  Benchmark time (default: 30)
        --warmup=[5]                 Benchmark warmup (default: 5)
    -h, --help                       How to use
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/honey_format. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
