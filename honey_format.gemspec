# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'honey_format/version'

Gem::Specification.new do |spec|
  spec.name          = 'honey_format'
  spec.version       = HoneyFormat::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = 'Convert CSV to objects.'
  spec.description   = 'Convert CSV to an array of objects with with ease. Create objects for each row with methods matching the column names. No dependencies other than Ruby stdlib.'
  spec.homepage      = 'https://github.com/buren/honey_format'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'byebug'
end
