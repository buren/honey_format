# frozen_string_literal: true

require 'spec_helper'

describe HoneyFormat::RowBuilder do
  describe '#initialize' do
    it 'fails with HoneyFormat::EmptyRowColumnsError when initialized empty array' do
      expect do
        described_class.new([])
      end.to raise_error(HoneyFormat::EmptyRowColumnsError)
    end

    it 'fails with HoneyFormat::RowError when initialized empty array' do
      expect do
        described_class.new([])
      end.to raise_error(HoneyFormat::RowError)
    end
  end

  describe '#build' do
    it 'calls the injected builder' do
      expected = 'changed'
      builder = ->(row) { row.id = expected; row } # rubocop:disable Style/Semicolon
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

    it 'does not break if type_map has a non present column' do
      row = described_class.new(:id, type_map: { id: :integer, thing: :decimal })

      expect do
        row.build(['1']).id
      end.to raise_error(HoneyFormat::Errors::UnknownTypeMapColumnError)
    end

    it 'builds struct from single symbol' do
      row = described_class.new(:id, type_map: { id: :integer })
      result = row.build(['1']).id
      expect(result).to eq(1)
    end

    it 'can have spec chars column names' do
      expected = 'value'
      row = described_class.new(:ÅÄÖ)
      result = row.build(expected).ÅÄÖ # rubocop:disable Naming/AsciiIdentifiers
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

    it 'fails with HoneyFormat::InvalidRowLengthError when passed a row longer than specified columns' do
      row = described_class.new([:id])
      expect do
        row.build([nil, nil])
      end.to raise_error(HoneyFormat::InvalidRowLengthError)
    end

    it 'fails with HoneyFormat::RowError when passed a row longer than specified columns' do
      row = described_class.new([:id])
      expect do
        row.build([nil, nil])
      end.to raise_error(HoneyFormat::RowError)
    end

    it 'builds when passed a shorter row than specified columns' do
      expected = 'expected'
      row = described_class.new(%i(id username))
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
