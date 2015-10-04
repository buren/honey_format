require 'spec_helper'

describe HoneyFormat::Row do
  let(:invalid_col_klass) { HoneyFormat::InvalidColumnsForRow }
  let(:invalid_row_length_klass) { HoneyFormat::InvalidRowLengthError }

  describe '#initialize' do
    it 'fails when initialized empty array' do
      expect do
        described_class.new([])
      end.to raise_error(invalid_col_klass)
    end
  end

  describe '#build' do
    it 'builds struct from single symbol' do
      expected = 'value'
      row = described_class.new(:id)
      result = row.build(expected).id
      expect(result).to eq(expected)
    end

    it 'builds struct from "weird" symbol' do
      expected = 'value'
      row = described_class.new(:"first-name")
      result = row.build(expected).public_send(:"first-name")
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
end
