# frozen_string_literal: true

require 'spec_helper'

require 'honey_format/converters/converter_registry'

RSpec.describe HoneyFormat::ConverterRegistry do
  let(:default_converters) { HoneyFormat.config.default_converters }

  describe '#reset!' do
    it 'returns new instance of converter registry' do
      converter_registry = described_class.new(default_converters)
      converter_registry.register(:watman, proc {})
      converter_registry.reset!

      expect(converter_registry.type?(:watman)).to eq(false)
    end
  end

  describe '#unregister' do
    it 'can unregister known type' do
      converter_registry = described_class.new(default_converters)
      converter_registry.register(:watman, proc {})
      converter_registry.unregister(:watman)

      expect(converter_registry.type?(:watman)).to eq(false)
    end

    it 'raises UnknownTypeError when trying to unregister unknown type' do
      converter_registry = described_class.new(default_converters)
      expect do
        converter_registry.unregister(:watman)
      end.to raise_error(HoneyFormat::UnknownTypeError)
    end
  end

  describe '#register' do
    it 'can register type' do
      converter_registry = described_class.new(default_converters)
      converter_registry.register(:watman, proc {})
      expect(converter_registry.type?(:watman)).to eq(true)

      # we must reset the conveter, since its global configuration
      converter_registry.reset!
    end

    it 'raises TypeExistsError when trying to register duplicated type' do
      converter_registry = described_class.new(default_converters)
      expect do
        converter_registry.register(:datetime!, proc {})
      end.to raise_error(HoneyFormat::TypeExistsError)
    end
  end

  describe '#types' do
    it 'returns the register types' do
      expected = %i[
        decimal! integer! date! datetime! symbol! downcase! upcase! boolean!
        decimal decimal_or_zero integer integer_or_zero
        date datetime symbol downcase upcase boolean md5 hex nil blank
        header_column
      ]
      expect(described_class.new(default_converters).types).to eq(expected)
    end
  end
end
