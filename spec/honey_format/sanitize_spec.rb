require 'spec_helper'

describe HoneyFormat::Sanitize do
  describe '#array!' do
    it 'calls strip on each element' do
      expect(described_class.array!(['  id  '])). to eq(['id'])
    end

    it 'returns empty array when passed empty array' do
      expect(described_class.array!([])). to eq([])
    end
  end

  describe '#column' do
    it 'strips all leading and trailing spaces' do
      expect(described_class.string!('  id  ')). to eq('id')
    end

    it 'returns nil if passed nil' do
      expect(described_class.string!(nil)). to eq(nil)
    end
  end
end
