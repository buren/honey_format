require 'spec_helper'

describe HoneyFormat::Header do
  describe '#initialize' do
    it 'fails when header is nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(HoneyFormat::MissingCSVHeaderError)
    end

    it 'fails when header is empty' do
      expect do
        described_class.new([])
      end.to raise_error(HoneyFormat::MissingCSVHeaderError)
    end

    it 'fails when a header column is empty' do
      expect do
        described_class.new(['first', ''])
      end.to raise_error(HoneyFormat::MissingCSVHeaderColumnError)
    end

    context 'when given a valid argument' do
      it 'fails when a column is found that is not in valid argument' do
        expect do
          described_class.new(%w[first third], valid: %w[first second])
        end.to raise_error(HoneyFormat::UnknownCSVHeaderColumnError)
      end

      it 'does not fail when all columns are valid' do
        cols = %w[first second]
        header = described_class.new(cols, valid: cols)
        expect(header.to_a).to eq(cols.map(&:to_sym))
      end
    end
  end

  describe 'quacks like an enumerable' do
    it 'can #map' do
      header = described_class.new(%w[first])

      expect(header.map { 'watman' }).to eq(%w[watman])
    end
  end

  describe '#original' do
    it 'can return original column names' do
      value = 'My id (string)'
      expect(described_class.new([value]).original).to eq([value])
    end
  end

  describe '#to_csv' do
    it 'returns the header as a CSV-string' do
      header = described_class.new(%w[name email])

      expect(header.to_csv).to eq("name,email\n")
    end
  end
end
