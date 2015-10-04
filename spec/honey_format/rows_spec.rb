require 'spec_helper'

describe HoneyFormat::Rows do
  describe '#to_a' do
    it 'returns an array of Row instances' do
      expected = 'buren'
      row = [expected]
      result = described_class.new([row], [:id]).to_a.first.id
      expect(result).to eq(expected)
    end

    it 'returns an array of Row instances' do
      result = described_class.new([[nil]], [:id]).to_a
      expect(result).to be_empty
    end
  end
end
