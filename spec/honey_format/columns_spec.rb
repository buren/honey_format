require 'spec_helper'

describe HoneyFormat::Columns do
  let(:missing_column_klass) { HoneyFormat::MissingCSVHeaderColumnError }

  describe '#initialize' do
    it 'fails when column empty' do
      expect do
        described_class.new(['Id', ''])
      end.to raise_error(missing_column_klass)
    end
  end

  describe '#to_a' do
    it 'can build columns' do
      result = described_class.new(['id', 'username']).to_a
      expect(result).to eq([:id, :username])
    end

    it 'replaces whitespace with underscores' do
      result = described_class.new(['first name']).to_a
      expect(result).to eq([:first_name])
    end

    it 'lowercases the string' do
      result = described_class.new(['ID','USeRnaMe']).to_a
      expect(result).to eq([:id, :username])
    end

    it 'can have column with underscores' do
      result = described_class.new(['first_name']).to_a
      expect(result).to eq([:first_name])
    end

    it 'can have column with dashes' do
      result = described_class.new(['first-name']).to_a
      expect(result).to eq([:first_name])
    end

    it 'can have spec chars column names' do
      result = described_class.new(['ÅÄÖ']).to_a.first
      expect(result).to eq(:åäö)
    end

    it 'can have ruby syntax chars as column names' do
      result = described_class.new(['ids(list of things)']).to_a.first
      expect(result).to eq(:"ids(list_of_things)")
    end
  end
end
