require 'spec_helper'

describe HoneyFormat::Row do
  let(:invalid_col_klass) { HoneyFormat::EmptyColumnsError }
  let(:invalid_row_length_klass) { HoneyFormat::InvalidRowLengthError }

  describe '#initialize' do
    it 'fails when initialized empty array' do
      expect do
        described_class.new([])
      end.to raise_error(invalid_col_klass)
    end
  end

  describe '#build' do
    it 'calls the injected builder' do
      expected = 'changed'
      builder = ->(row) { row.id = expected; row }
      row = described_class.new(:id, builder: builder)
      result = row.build('value').id
      expect(result).to eq(expected)
    end

    it 'builds struct from single symbol' do
      expected = 'value'
      row = described_class.new(:id)
      result = row.build(expected).id
      expect(result).to eq(expected)
    end

    it 'can have spec chars column names' do
      expected = 'value'
      row = described_class.new(:ÅÄÖ)
      result = row.build(expected).ÅÄÖ
      expect(result).to eq(expected)
    end

    it 'can have spec chars column names' do
      expected = 'value'
      row = described_class.new(:"ids(list of things)")
      result = row.build(expected).public_send(:"ids(list of things)")
      expect(result).to eq(expected)
    end

    it 'builds struct from row array' do
      expected = 'value'
      row = described_class.new([:id])
      result = row.build(expected).id
      expect(result).to eq(expected)
    end

    it 'fails when passed a row longer than specified columns' do
      row = described_class.new([:id])
      expect do
        row.build([nil, nil])
      end.to raise_error(invalid_row_length_klass)
    end

    it 'builds when passed a shorter row than specified columns' do
      expected = 'expected'
      row = described_class.new([:id, :username])
      expect(row.build([expected]).id).to eq(expected)
      expect(row.build([expected]).username).to eq(nil)
    end
  end

  describe '#to_csv' do
    it 'returns the row as a CSV-string' do
      header = described_class.new(%i[col1 col2])
      columns = %w[first second]

      expect(header.build(columns).to_csv).to eq("first,second\n")
    end
  end
end
