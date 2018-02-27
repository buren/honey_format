require 'spec_helper'

describe HoneyFormat::Sanitize do
  describe '#array' do
    it 'calls strip on each element' do
      expect(described_class.array(['  id  '])). to eq(['id'])
    end

    it 'returns empty array when passed empty array' do
      expect(described_class.array([])). to eq([])
    end
  end

  describe '#string' do
    it 'strips all leading and trailing spaces' do
      expect(described_class.string('  id  ')). to eq('id')
    end

    it 'returns nil if passed nil' do
      expect(described_class.string(nil)). to eq(nil)
    end
  end

  describe '#array!' do
    it 'calls strip on each element and mutates argument' do
      value = ['  id  ']
      described_class.array!(value)
      expect(value). to eq(['id'])
    end

    it 'returns empty array when passed empty array' do
      expect(described_class.array!([])). to eq([])
    end
  end

  describe '#string!' do
    it 'strips all leading and trailing spaces and mutates argument' do
      value = '  id  '
      described_class.string!(value)
      expect(value). to eq('id')
    end

    it 'returns nil if passed nil' do
      expect(described_class.string!(nil)). to eq(nil)
    end
  end
end
