if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'honey_format'
