# frozen_string_literal: true

require 'spec_helper'

describe HoneyFormat::Rows do
  describe '#columns' do
    it 'returns given columns' do
      rows = described_class.new(%w[first second], %i[name])

      expect(rows.columns).to eq(%i[name])
    end
  end

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

  describe 'empty?' do
    it 'returns true when empty' do
      rows = described_class.new(%w[], %i[name])

      expect(rows.empty?).to eq(true)
    end

    it 'returns false when not empty' do
      rows = described_class.new(%w[first], %i[name])

      expect(rows.empty?).to eq(false)
    end
  end

  it 'can return the rows length' do
    rows = described_class.new(%w[first second], %i[name])

    expect(rows.length).to eq(2)
  end

  describe '#[]' do
    it 'can return element at position' do
      rows = described_class.new(%w[first second], %i[name])

      expect(rows[0].name).to eq('first')
      expect(rows[1].name).to eq('second')
      expect(rows[-1].name).to eq('second')
    end

    it 'returns nil if requesting element outside of length' do
      rows = described_class.new(%w[first second], %i[name])

      expect(rows[999]).to be_nil
    end
  end

  describe '#to_csv' do
    it 'returns the rows as a CSV-string' do
      matrix = [%w[first thing], %w[second thing]]
      rows = described_class.new(matrix, %i(col1 col2))

      expect(rows.to_csv).to eq("first,thing\nsecond,thing\n")
    end

    it 'returns the rows as a CSV-string with selected columns as symbols' do
      matrix = [%w[buren 28 Sweden]]
      rows = described_class.new(matrix, %i[name age country])

      expect(rows.to_csv(columns: %i[country age])).to eq("28,Sweden\n")
    end

    it 'returns the rows as a CSV-string with selected columns as strings' do
      matrix = [%w[buren 28 Sweden]]
      rows = described_class.new(matrix, %i[name age country])

      expect(rows.to_csv(columns: %w[country age])).to eq("28,Sweden\n")
    end

    it 'returns the rows as a CSV-string with selected rows' do
      matrix = [%w[buren Sweden], %w[jacob Denmark]]
      rows = described_class.new(matrix, %i[name country])

      expect(rows.to_csv { |row| row.country == 'Sweden' }).to eq("buren,Sweden\n")
    end
  end

  describe '#+' do
    it 'can be added added with an other compatible Rows object' do
      expected_x = 'buren'
      expected_y = 'jacob'
      x = described_class.new([[expected_x]], %i[id])
      y = described_class.new([[expected_y]], %i[id])

      result = x + y
      expect(result[0].id).to eq(expected_x)
      expect(result[1].id).to eq(expected_y)
      expect(result.size).to eq(2)
      # Make sure the x and y are not mutated
      expect(x.size).to eq(1)
      expect(y.size).to eq(1)
    end

    it 'raises ArgumentError when two incompatible sets of rows are added together' do
      x = described_class.new([['buren', 2]], %i[id minimum])
      y = described_class.new([['jacob', 1]], %i[id maximum])

      expect { x + y }.to raise_error(ArgumentError)
    end
  end

  describe 'quacks like an Enumerable' do
    it 'has working #map method' do
      matrix = [%w[first thing], %w[second thing]]
      rows = described_class.new(matrix, %i(col1 col2))

      rows = rows.map(&:col1)

      expect(rows).to eq(%w[first second])
    end
  end
end
