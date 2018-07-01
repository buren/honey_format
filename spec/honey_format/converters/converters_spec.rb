# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::Registry do
  let(:default_converters) { HoneyFormat.config.default_converters }

  describe 'nil type' do
    it 'converts value to nil' do
      converter = described_class.new(default_converters)
      value = converter.call('buren', :nil)
      expect(value).to be_nil
    end
  end

  it 'can convert custom value' do
    registry = described_class.new(default_converters)
    registry.register(:upcased, proc { |v| v.upcase })
    value = registry.call('buren', :upcased)
    expect(value).to eq('BUREN')
  end

  it 'raises ArgumentError if an unknown type is passed' do
    registry = described_class.new(default_converters)
    expect do
      registry.call(nil, :watman)
    end.to raise_error(ArgumentError)
  end
end
