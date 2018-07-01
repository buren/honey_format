# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::ConvertBoolean do
  describe 'boolean type' do
    %w[t T 1 y Y true TRUE].each do |input|
      it "can convert #{input} to true" do
        value = described_class.call(input)
        expect(value).to eq(true)
      end
    end

    %w[f F 0 n N false FALSE].each do |input|
      it "can convert #{input} to false" do
        value = described_class.call(input)
        expect(value).to eq(false)
      end
    end

    [nil, 'asd', '2', '', '11', '00'].each do |input|
      it "returns nil for #{input}" do
        value = described_class.call(input)
        expect(value).to be_nil
      end
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertBoolean do
  describe 'boolean! type' do
    %w[t T 1 y Y true TRUE].each do |input|
      it "can convert #{input} to true" do
        value = described_class.call(input)
        expect(value).to eq(true)
      end
    end

    %w[f F 0 n N false FALSE].each do |input|
      it "can convert #{input} to false" do
        value = described_class.call(input)
        expect(value).to eq(false)
      end
    end

    [nil, 'asd', '2', '', '11', '00'].each do |input|
      it "raises ArgumentError if type can't be converted" do
        expect do
          described_class.call(input)
        end.to raise_error(ArgumentError)
      end
    end
  end
end
