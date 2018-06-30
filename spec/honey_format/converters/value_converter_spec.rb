# frozen_string_literal: true

require 'spec_helper'

require 'honey_format/converters/value_converter'

RSpec.describe HoneyFormat::ValueConverter do
  let(:default_converters) { HoneyFormat.config.default_converters }

  describe '#reset!' do
    it 'returns new instance of value converter' do
      value_converter = described_class.new(default_converters)
      value_converter.register(:watman, proc {})
      value_converter.reset!

      expect(value_converter.type?(:watman)).to eq(false)
    end
  end

  describe '#unregister' do
    it 'can unregister known type' do
      value_converter = described_class.new(default_converters)
      value_converter.register(:watman, proc {})
      value_converter.unregister(:watman)

      expect(value_converter.type?(:watman)).to eq(false)
    end

    it 'raises Errors::UnknownTypeError when trying to unregister unknown type' do
      value_converter = described_class.new(default_converters)
      expect do
        value_converter.unregister(:watman)
      end.to raise_error(HoneyFormat::Errors::UnknownTypeError)
    end
  end

  describe '#register' do
    it 'can register type' do
      value_converter = described_class.new(default_converters)
      value_converter.register(:watman, proc {})
      expect(value_converter.type?(:watman)).to eq(true)

      # we must reset the conveter, since its global configuration
      value_converter.reset!
    end

    it 'raises Errors::ValueTypeExistsError when trying to register duplicated type' do
      value_converter = described_class.new(default_converters)
      expect do
        value_converter.register(:datetime!, proc {})
      end.to raise_error(HoneyFormat::Errors::ValueTypeExistsError)
    end
  end

  describe '#types' do
    it 'returns the register types' do
      expected = %i[
        decimal! integer! date! datetime! symbol! downcase! upcase! boolean!
        decimal decimal_or_zero integer integer_or_zero
        date datetime symbol downcase upcase boolean md5 hex nil
        header_column
      ]
      expect(described_class.new(default_converters).types).to eq(expected)
    end
  end
end
