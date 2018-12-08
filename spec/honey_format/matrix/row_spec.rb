# frozen_string_literal: true

require 'spec_helper'

require 'set'

describe HoneyFormat::Row do
  describe '::call' do
    it 'returns an object representing the row' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)

      expect(person.name).to eq('buren')
      expect(person.age).to eq(28)
    end
  end

  describe '#to_h' do
    it 'returns row as hash' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)

      expect(person.to_h).to eq(name: 'buren', age: 28)
    end
  end

  describe 'enumerable' do
    it 'acts like an enumerable' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)
      itr = person.each
      expect(itr.next).to eq('buren')
      expect(itr.next).to eq(28)
    end
  end

  describe '#inspect' do
    it 'returns nicely formatted string representation of row' do
      row = described_class.call(%i[name age])
      person = row.new('buren', 28)

      expect(person.inspect).to eq('#<Row name="buren", age=28>')
    end

    it 'aliases #inspect to #to_s' do
      row = described_class.call(%i[name age])
      person = row.new('buren', 28)

      expect(person.to_s).to eq(person.inspect)
    end
  end

  describe '#to_csv' do
    it 'returns the row as a CSV-string' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)

      expect(person.to_csv).to eq("buren,28\n")
    end

    it 'returns the row as a CSV-string with selected columns' do
      struct = described_class.call(%i[name age country])
      person = struct.new('buren', 28, 'Sweden')

      expect(person.to_csv(columns: %i(age country))).to eq("28,Sweden\n")
    end

    it 'returns the row as a CSV-string with selected columns (passed as Set object)' do
      struct = described_class.call(%i[name age country])
      person = struct.new('buren', 28, 'Sweden')

      columns = Set.new(%i(age country))
      expect(person.to_csv(columns: columns)).to eq("28,Sweden\n")
    end

    it 'handles empty cell' do
      struct = described_class.call(%i[name age])
      person = struct.new('jacob')

      expect(person.to_csv).to eq("jacob,\n")
    end

    it 'handles strings containing a CSV-delimiter character' do
      struct = described_class.call(%i[name age])
      person = struct.new('jacob,buren', 28)

      expect(person.to_csv).to eq("\"jacob,buren\",28\n")
    end

    it 'handles strings containing a quote characters' do
      struct = described_class.call(%i[name age])
      person = struct.new('jacob "buren" burenstam', 28)

      expect(person.to_csv).to eq("\"jacob \"\"buren\"\" burenstam\",28\n")
    end

    it 'handles strings containing a quote character' do
      struct = described_class.call(%i[name age])
      person = struct.new('jacob buren" burenstam', 28)

      expect(person.to_csv).to eq("\"jacob buren\"\" burenstam\",28\n")
    end

    it 'handles strings containing a new line character' do
      struct = described_class.call(%i[name age])
      person = struct.new("jacob\nburen", 28)

      expect(person.to_csv).to eq("\"jacob\nburen\",28\n")
    end

    it 'calls #to_csv if supported for each of the members in the Struct' do
      struct = described_class.call(%i[name age])
      name_object = Class.new { define_method(:to_csv) { 'buren' } }.new
      person = struct.new(name_object, 28)

      expect(person.to_csv).to eq("buren,28\n")
    end

    it 'calls #to_s for each of the members in the Struct if #to_csv is not supported' do
      struct = described_class.call(%i[name age])
      name_object = Class.new { define_method(:to_s) { 'buren' } }.new
      person = struct.new(name_object, 28)

      expect(person.to_csv).to eq("buren,28\n")
    end
  end
end
