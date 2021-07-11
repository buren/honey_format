# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::ConvertBabosa do
  it 'can convert' do
    babosa_string = 'my () ruby method--Name'
    value = described_class.call(babosa_string)
    expect(value).to eq(:my_ruby_method_name)
  end

  it 'can convert number like value' do
    value = described_class.call('1.1')

    expect(value).to eq(:'11')
  end

  it 'returns nil for empty string' do
    value = described_class.call('')

    expect(value).to be_nil
  end

  context 'when babosa gem not loaded' do
    it 'raises ArgumentError when called' do
      stub_const('BABOSA_LOADED', false)

      expect do
        described_class.call('')
      end.to raise_error(HoneyFormat::Errors::BabosaNotLoadedError)
    end
  end
end
