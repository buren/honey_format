require 'spec_helper'

describe HoneyFormat::Rows do
  describe '#to_a' do
    it 'returns an array of Row instances' do
      expected = 'buren'
      row = [expected]
      result = described_class.new([row], [:id]).to_a.first.id
      expect(result).to eq(expected)
    end

    it 'returns an array of Row instances' do
      result = described_class.new([[nil]], [:id]).to_a
      expect(result).to be_empty
    end
  end

  describe '#to_csv' do
    it 'returns the rows as a CSV-string' do
      matrix = [%w[first thing], %w[second thing]]
      rows = described_class.new(matrix, [:col1, :col2])

      expect(rows.to_csv).to eq("first,thing\nsecond,thing\n")
    end
  end
end
