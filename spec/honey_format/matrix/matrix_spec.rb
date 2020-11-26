# frozen_string_literal: true

require 'spec_helper'

describe HoneyFormat::Matrix do
  describe '#type_map' do
    it 'returns type map' do
      data = [[:id, :name], ['1', 'jacob']]
      type_map = { id: :integer }
      matrix = described_class.new(data, type_map: type_map)

      expect(matrix.type_map).to eq({ id: :integer })
    end
  end
end