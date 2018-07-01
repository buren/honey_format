# frozen_string_literal: true

require 'spec_helper'
require 'honey_format/helpers/helpers'

RSpec.describe HoneyFormat::Helpers do
  describe '::key_count_to_deduplicated_array' do
    it 'converts hash data to deduplicated array' do
      data = %i[a a b]
      result = described_class.key_count_to_deduplicated_array(data)
      expect(result).to eq(%i[a a1 b])
    end
  end

  describe '::duplicated_items' do
    it 'returns empty array if no duplicates are found' do
      expect(described_class.duplicated_items([1, 2])).to be_empty
    end

    it 'returns duplicates in array' do
      expect(described_class.duplicated_items([1, 2, 1])).to eq([1])
    end
  end

  describe '::count_occurences' do
    it 'returns empty hash for now array' do
      expect(described_class.count_occurences([])).to be_empty
    end

    it 'returns occurrences count' do
      expect(described_class.count_occurences(%i[a b a])).to eq(a: 2, b: 1)
    end
  end
end
