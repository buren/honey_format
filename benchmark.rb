require 'benchmark/ips'
require 'csv'

require 'bundler/setup'
require 'honey_format'

csv = File.read('benchmark.csv')

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 2

  x.report("stdlib CSV") { CSV.parse(csv) }
  x.report("HoneyFormat::CSV") { HoneyFormat::CSV.new(csv).rows }

  x.compare!
end
