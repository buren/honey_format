require 'spec_helper'

require 'honey_format/value_coercer'

Rspec.describe HoneyFormat::ValueCoercer do
  it 'can coerce integer' do
    value = described_class.new.coerce('1', :integer)
    expect(value).to eq(1)
  end

  it 'can coerce decimal' do
    value = described_class.new.coerce('1.1', :decimal)
    expect(value).to eq(1.1)
  end

  it 'can coerce custom value' do
    value_coercer = described_class.new
    value_coercer.register(:upcased, proc { |v| v.upcase })
    value = value_coercer.coerce('buren', :upcased)
    expect(value).to eq('BUREN')
  end

  it 'raises ArgumentError when trying to register duplicated type' do
    value_coercer = described_class.new
    expect do
      value_coercer.register(:datetime, proc {})
    end.to raise_error(ArgumentError)
  end

  it 'raises ArgumentError if an unknown type is passed' do
    value_coercer = described_class.new
    expect do
      value_coercer.coerce(nil, :watman)
    end.to raise_error(ArgumentError)
  end

  it 'can coerce date' do
    date_string = '2018-01-01'
    value = described_class.new.coerce(date_string, :date)
    expected = Date.parse('2018-01-01')
    expect(value).to eq(expected)
  end
end
