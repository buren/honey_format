require 'spec_helper'

require 'honey_format/row_builder'

describe HoneyFormat::RowBuilder do
  describe '::call' do
    it 'returns an instantiated Struct' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)

      expect(person.name).to eq('buren')
      expect(person.age).to eq(28)
    end
  end

  describe '#to_csv' do
    it 'returns the row as a CSV-string' do
      struct = described_class.call(%i[name age])
      person = struct.new('buren', 28)

      expect(person.to_csv).to eq("buren,28\n")
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
