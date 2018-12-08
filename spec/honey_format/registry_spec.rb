# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::Registry do
  let(:default_converters) { HoneyFormat.config.default_converters }

  describe '#type?' do
    it 'returns false when key is invalid' do
      registry = described_class.new
      expect(registry.type?({})).to eq(false)
    end

    it 'returns fals when key is not present' do
      registry = described_class.new
      expect(registry.type?(:watman)).to eq(false)
    end

    it 'returns true when key is a Symbol and present' do
      registry = described_class.new(default_converters)
      expect(registry.type?(:integer)).to eq(true)
    end

    it 'returns true when key is a String and present' do
      registry = described_class.new(default_converters)
      expect(registry.type?('integer')).to eq(true)
    end
  end

  describe '#reset!' do
    it 'returns new instance of converter registry' do
      registry = described_class.new(default_converters)
      registry.register(:watman, proc {})
      registry.reset!

      expect(registry.type?(:watman)).to eq(false)
    end
  end

  describe '#unregister' do
    it 'can unregister known type' do
      registry = described_class.new(default_converters)
      registry.register(:watman, proc {})
      registry.unregister(:watman)

      expect(registry.type?(:watman)).to eq(false)
    end

    it 'raises UnknownTypeError when trying to unregister unknown type' do
      registry = described_class.new(default_converters)
      expect do
        registry.unregister(:watman)
      end.to raise_error(HoneyFormat::UnknownTypeError)
    end
  end

  describe '#register' do
    it 'can register type' do
      registry = described_class.new(default_converters)
      registry.register(:watman, proc {})
      expect(registry.type?(:watman)).to eq(true)

      # we must reset the conveter, since its global configuration
      registry.reset!
    end

    it 'raises TypeExistsError when trying to register duplicated type' do
      registry = described_class.new(default_converters)
      expect do
        registry.register(:datetime!, proc {})
      end.to raise_error(HoneyFormat::TypeExistsError)
    end
  end

  describe '#types' do
    it 'returns the register types' do
      expected = %i[
        decimal! integer! date! datetime! symbol! downcase! upcase! boolean!
        decimal decimal_or_zero integer integer_or_zero
        date datetime symbol downcase upcase boolean md5 hex nil blank
        header_column method_name
      ]
      expect(described_class.new(default_converters).types).to eq(expected)
    end
  end

  describe '#call' do
    it 'calls the registered type' do
      registry = described_class.new(default_converters)
      expect(registry.call('1', :integer)).to eq(1)
    end

    it 'calls #call on type if passed proc' do
      registry = described_class.new(default_converters)
      expect(registry.call('1', proc { |v| v.to_i })).to eq(1)
    end

    it 'calls #call on type if passed object that responds to #call' do
      registry = described_class.new(default_converters)
      type = Class.new { define_method(:call) { |v| v.to_i } }.new
      expect(registry.call('1', type)).to eq(1)
    end
  end
end
