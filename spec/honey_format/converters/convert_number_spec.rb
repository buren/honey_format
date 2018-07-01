# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::ConvertDecimal do
  describe 'decimal type' do
    it 'can convert' do
      value = described_class.call('1.1')
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      value = described_class.call('1')
      expect(value).to eq(1.0)
    end

    it "returns nil if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::ConvertDecimalOrZero do
  describe 'decimal_or_zero type' do
    it 'can convert' do
      value = described_class.call('1.1')
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      value = described_class.call('1')
      expect(value).to eq(1.0)
    end

    it "returns 0.0 if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to eq(0.0)
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertDecimal do
  describe 'decimal! type' do
    it 'can convert' do
      value = described_class.call('1.1')
      expect(value).to eq(1.1)
    end

    it 'returns 1.0 if when passed "1"' do
      value = described_class.call('1')
      expect(value).to eq(1.0)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.call('aa')
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertInteger do
  describe 'integer type' do
    it 'can convert' do
      value = described_class.call('1')
      expect(value).to eq(1)
    end

    it "returns nil if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::ConvertIntegerOrZero do
  describe 'integer_or_zero type' do
    it 'can convert' do
      value = described_class.call('1')
      expect(value).to eq(1)
    end

    it "returns 0 if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to eq(0)
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertInteger do
  describe 'integer! type' do
    it 'can convert' do
      value = described_class.call('1')
      expect(value).to eq(1)
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.call('aa')
      end.to raise_error(ArgumentError)
    end
  end
end
