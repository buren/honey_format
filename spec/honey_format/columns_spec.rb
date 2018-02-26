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
  end
end
