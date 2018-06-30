# frozen_string_literal: true

require 'spec_helper'

require 'honey_format/converters/converter_registry'

RSpec.describe HoneyFormat::ConverterRegistry do
  let(:default_converters) { HoneyFormat.config.default_converters }

  describe 'integer! type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :integer!)
      expect(value).to eq(1)
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.new.call('aa', :integer!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'integer type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :integer)
      expect(value).to eq(1)
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :integer)
      expect(value).to be_nil
    end
  end

  describe 'integer_or_zero type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :integer_or_zero)
      expect(value).to eq(1)
    end

    it "returns 0 if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :integer_or_zero)
      expect(value).to eq(0)
    end
  end

  describe 'boolean! type' do
    %w[t T 1 y Y true TRUE].each do |input|
      it "can convert #{input} to true" do
        converter = described_class.new(default_converters)
        value = converter.call(input, :boolean!)
        expect(value).to eq(true)
      end
    end

    %w[f F 0 n N false FALSE].each do |input|
      it "can convert #{input} to false" do
        converter = described_class.new(default_converters)
        value = converter.call(input, :boolean!)
        expect(value).to eq(false)
      end
    end

    [nil, 'asd', '2', '', '11', '00'].each do |input|
      it "raises ArgumentError if type can't be converted" do
        expect do
          described_class.new.call(input, :boolean!)
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe 'boolean type' do
    %w[t T 1 y Y true TRUE].each do |input|
      it "can convert #{input} to true" do
        converter = described_class.new(default_converters)
        value = converter.call(input, :boolean)
        expect(value).to eq(true)
      end
    end

    %w[f F 0 n N false FALSE].each do |input|
      it "can convert #{input} to false" do
        converter = described_class.new(default_converters)
        value = converter.call(input, :boolean)
        expect(value).to eq(false)
      end
    end

    [nil, 'asd', '2', '', '11', '00'].each do |input|
      it "returns nil for #{input}" do
        converter = described_class.new(default_converters)
        value = converter.call(input, :boolean)
        expect(value).to be_nil
      end
    end
  end

  describe 'decimal type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1.1', :decimal)
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :decimal)
      expect(value).to eq(1.0)
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :decimal)
      expect(value).to be_nil
    end
  end

  describe 'decimal_or_zero type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1.1', :decimal_or_zero)
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :decimal_or_zero)
      expect(value).to eq(1.0)
    end

    it "returns 0.0 if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :decimal_or_zero)
      expect(value).to eq(0.0)
    end
  end

  describe 'decimal! type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1.1', :decimal!)
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :decimal!)
      expect(value).to eq(1.0)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.new.call('aa', :decimal!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'date! type' do
    it 'can convert' do
      date_string = '2018-01-01'
      converter = described_class.new(default_converters)
      value = converter.call(date_string, :date!)
      expected = Date.parse('2018-01-01')
      expect(value).to eq(expected)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.new.call('aa', :date!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'date type' do
    it 'can convert' do
      date_string = '2018-01-01'
      converter = described_class.new(default_converters)
      value = converter.call(date_string, :date!)
      expected = Date.parse('2018-01-01')
      expect(value).to eq(expected)
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :date)
      expect(value).to be_nil
    end
  end

  describe 'datetime! type' do
    it 'can convert' do
      time_string = '2018-01-01 00:15'
      converter = described_class.new(default_converters)
      value = converter.call(time_string, :datetime)
      expected = Time.parse('2018-01-01 00:15')
      expect(value).to eq(expected)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.new.call('aa', :datetime!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'datetime type' do
    it 'can convert' do
      time_string = '2018-01-01 00:15'
      converter = described_class.new(default_converters)
      value = converter.call(time_string, :datetime)
      expected = Time.parse('2018-01-01 00:15')
      expect(value).to eq(expected)
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call('aa', :datetime)
      expect(value).to be_nil
    end
  end

  describe 'symbol! type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :symbol!)
      expect(value).to eq(:"1")
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.new.call(nil, :symbol!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'symbol type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('1', :symbol)
      expect(value).to eq(:'1')
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call(nil, :symbol)
      expect(value).to be_nil
    end
  end

  describe 'downcase! type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('BUREN', :downcase!)
      expect(value).to eq('buren')
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.new.call(nil, :downcase!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'downcase type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('BUREN', :downcase)
      expect(value).to eq('buren')
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call(nil, :downcase)
      expect(value).to be_nil
    end
  end

  describe 'upcase! type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :upcase!)
      expect(value).to eq('BUREN')
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.new.call(nil, :upcase!)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'upcase type' do
    it 'can convert' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :upcase)
      expect(value).to eq('BUREN')
    end

    it "returns nil if value can't be converted" do
      converter = described_class.new(default_converters)
      value = converter.call(nil, :upcase)
      expect(value).to be_nil
    end
  end

  describe 'nil type' do
    it 'converts value to nil' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :nil)
      expect(value).to be_nil
    end
  end

  describe 'md5 type' do
    it 'return nil when given nil' do
      converter = described_class.new(default_converters)
      value = converter.call(nil, :md5)
      expect(value).to be_nil
    end

    it 'converts value to MD5' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :md5)
      value1 = converter.call('buren', :md5)

      expect(value).not_to eq('buren')
      expect(value.length).to eq(32)
      expect(value).to eq(value1)
    end
  end

  describe 'hex type' do
    it 'return nil when given nil' do
      converter = described_class.new(default_converters)
      value = converter.call(nil, :hex)
      expect(value).to be_nil
    end

    it 'converts value to random hex' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :hex)
      value1 = converter.call('buren', :hex)

      expect(value).not_to eq('buren')
      expect(value.length).to eq(32)
      expect(value).not_to eq(value1)
    end
  end

  it 'can convert custom value' do
    converter_registry = described_class.new(default_converters)
    converter_registry.register(:upcased, proc { |v| v.upcase })
    value = converter_registry.call('buren', :upcased)
    expect(value).to eq('BUREN')
  end

  it 'raises ArgumentError if an unknown type is passed' do
    converter_registry = described_class.new(default_converters)
    expect do
      converter_registry.call(nil, :watman)
    end.to raise_error(ArgumentError)
  end
end
