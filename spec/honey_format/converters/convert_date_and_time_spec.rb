# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::StrictConvertDate do
  describe 'date! type' do
    it 'can convert' do
      date_string = '2018-01-01'
      value = described_class.call(date_string)
      expected = Date.parse('2018-01-01')
      expect(value).to eq(expected)
    end

    it 'returns same date if passed date' do
      date = Date.parse('2018-01-01')
      value = described_class.call(date)
      expected = Date.parse('2018-01-01')
      expect(value).to eq(expected)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.call('aa')
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertDate do
  describe 'date type' do
    it 'can convert YYYY-MM-DD' do
      date_string = '2018-01-01'
      value = described_class.call(date_string)
      expected = Date.parse('2018-01-01')
      expect(value).to eq(expected)
    end

    it 'can convert DD/MM/YYYY' do
      date_string = '31/01/2018'
      value = described_class.call(date_string)
      expected = Date.parse('2018-01-31')
      expect(value).to eq(expected)
    end

    it "returns nil if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertDatetime do
  describe 'datetime! type' do
    it 'can convert' do
      time_string = '2018-01-01 00:15'
      value = described_class.call(time_string)
      expected = Time.parse('2018-01-01 00:15')
      expect(value).to eq(expected)
    end

    it "raise ArgumentError if value can't be converted" do
      expect do
        described_class.call('aa')
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertDatetime do
  describe 'datetime type' do
    it 'can convert' do
      time_string = '2018-01-01 00:15'
      value = described_class.call(time_string)
      expected = Time.parse('2018-01-01 00:15')
      expect(value).to eq(expected)
    end

    it "returns nil if value can't be converted" do
      value = described_class.call('aa')
      expect(value).to be_nil
    end
  end
end
