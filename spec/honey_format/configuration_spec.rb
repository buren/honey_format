# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::Configuration do
  describe '#header_converter=' do
    it 'can set header converter from Symbol' do
      expected = HoneyFormat.converter[:upcase]

      config = described_class.new
      config.header_converter = :upcase

      expect(config.header_converter).to eq(expected)
    end

    it 'can set header converter' do
      expected = HoneyFormat.converter[:upcase]

      config = described_class.new
      config.header_converter = expected

      expect(config.header_converter).to eq(expected)
    end
  end

  describe '#converter' do
    it 'returns a converter registry' do
      expect(described_class.new.converter).to be_a(HoneyFormat::Registry)
    end
  end

  describe '#deduplicate_header=' do
    it 'can set header converter from Symbol' do
      config = described_class.new
      config.deduplicate_header = :none
      expected = config.default_deduplicate_header_strategies[:none]

      expect(config.deduplicate_header).to eq(expected)
    end

    it 'raises error for unknown Symbol deduplicator' do
      config = described_class.new

      expect do
        config.deduplicate_header = :invalid_thing
      end.to raise_error(HoneyFormat::Errors::UnknownDeduplicationStrategyError)
    end

    it 'raises error in invalid deduplicator' do
      config = described_class.new

      expect do
        config.deduplicate_header = 'wat'
      end.to raise_error(HoneyFormat::Errors::UnknownDeduplicationStrategyError)
    end

    it 'can set header converter' do
      expected = proc { |v| v }

      config = described_class.new
      config.deduplicate_header = expected

      expect(config.deduplicate_header).to eq(expected)
    end
  end
end
