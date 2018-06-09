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

  it 'can return the rows size' do
    rows = described_class.new(%w[first second], %i[name])

    expect(rows.size).to eq(2)
  end

  it 'can return the rows length' do
    rows = described_class.new(%w[first second], %i[name])

    expect(rows.length).to eq(2)
  end

  describe '#to_csv' do
    it 'returns the rows as a CSV-string' do
      matrix = [%w[first thing], %w[second thing]]
      rows = described_class.new(matrix, [:col1, :col2])

      expect(rows.to_csv).to eq("first,thing\nsecond,thing\n")
    end

    it 'returns the rows as a CSV-string with selected columns' do
      matrix = [%w[buren 28 Sweden]]
      rows = described_class.new(matrix, %i[name age country])

      expect(rows.to_csv(columns: %i[country age])).to eq("28,Sweden\n")
    end

    it 'returns the rows as a CSV-string with selected rows' do
      matrix = [%w[buren Sweden], %w[jacob Denmark]]
      rows = described_class.new(matrix, %i[name country])

      expect(rows.to_csv { |row| row.country == 'Sweden' }).to eq("buren,Sweden\n")
    end
  end

  describe 'quacks like an Enumerable' do
    it 'has working #map method' do
      matrix = [%w[first thing], %w[second thing]]
      rows = described_class.new(matrix, [:col1, :col2])

      rows = rows.map { |row| row.col1 }

      expect(rows).to eq(%w[first second])
    end
  end
end
