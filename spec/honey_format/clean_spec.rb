require 'spec_helper'

describe HoneyFormat::Clean do
  describe '#row' do
    it 'calls strip on each element' do
      expect(described_class.row(['  id  '])). to eq(['id'])
    end

    it 'returns empty array when passed empty array' do
      expect(described_class.row([])). to eq([])
    end
  end

  describe '#column' do
    it 'strips all leading and trailing spaces' do
      expect(described_class.column('  id  ')). to eq('id')
    end

    it 'returns nil if passed nil' do
      expect(described_class.column(nil)). to eq(nil)
    end
  end
end
