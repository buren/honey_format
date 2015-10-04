require 'spec_helper'

describe HoneyFormat::Columns do
  let(:missing_header_klass) { HoneyFormat::MissingCSVHeaderError }
  let(:missing_column_klass) { HoneyFormat::MissingCSVHeaderColumnError }

  describe '#initialize' do
    it 'can build columns' do
      result = described_class.new(['id', 'username']).to_a
      expect(result).to eq([:id, :username])
    end

    it 'removes whitespace and downcases columns' do
      result = described_class.new(['I    D', 'U  Se R na Me']).to_a
      expect(result).to eq([:id, :username])
    end

    it 'can have column with underscores' do
      result = described_class.new(['first_name']).to_a
      expect(result).to eq([:first_name])
    end

    it 'can have column with dashes' do
      result = described_class.new(['first-name']).to_a
      expect(result).to eq([:"first-name"])
    end

    it 'fails when column empty' do
      expect do
        described_class.new(['Id', ''])
      end.to raise_error(missing_column_klass)
    end

    it 'fails when all header column names not in valid_columns array' do
      expected_error = HoneyFormat::InvalidCSVHeaderColumnError
      expect do
        described_class.new(['id'], valid: [:asd]).header
      end.to raise_error(expected_error)
    end

    it 'fails when all header column names not in valid_columns array' do
      expected_error = HoneyFormat::MissingCSVHeaderColumnError
      expect do
        described_class.new([nil, 'ids']).header
      end.to raise_error(expected_error)
    end
  end

  describe '#header' do
    it 'fails when nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(missing_header_klass)
    end

    it 'fails when empty' do
      expect do
        described_class.new([])
      end.to raise_error(missing_header_klass)
    end
  end
end
