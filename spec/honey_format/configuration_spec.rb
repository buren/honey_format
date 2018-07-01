# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::Configuration do
  describe '#header_converter=' do
    it 'can set header converter from Symbol' do
      expected = HoneyFormat.converter_registry[:upcase]

      config = described_class.new
      config.header_converter = :upcase

      expect(config.header_converter).to eq(expected)
    end

    it 'can set header converter' do
      expected = HoneyFormat.converter_registry[:upcase]

      config = described_class.new
      config.header_converter = expected

      expect(config.header_converter).to eq(expected)
    end
  end

  describe '#converter' do
    it 'returns a converter registry' do
      expect(described_class.new.converter_registry).to be_a(HoneyFormat::Registry)
    end
  end

  describe '#header_deduplicator=' do
    it 'can set header converter from Symbol' do
      config = described_class.new
      config.header_deduplicator = :none
      expected = config.default_header_deduplicators[:none]

      expect(config.header_deduplicator).to eq(expected)
    end

    it 'raises error for unknown Symbol deduplicator' do
      config = described_class.new

      expect do
        config.header_deduplicator = :invalid_thing
      end.to raise_error(HoneyFormat::Errors::UnknownDeduplicationStrategyError)
    end

    it 'raises error in invalid deduplicator' do
      config = described_class.new

      expect do
        config.header_deduplicator = 'wat'
      end.to raise_error(HoneyFormat::Errors::UnknownDeduplicationStrategyError)
    end

    it 'can set header converter' do
      expected = proc { |v| v }

      config = described_class.new
      config.header_deduplicator = expected

      expect(config.header_deduplicator).to eq(expected)
    end
  end
end
