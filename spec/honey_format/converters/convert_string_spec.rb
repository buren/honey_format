# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HoneyFormat::ConvertDowncase do
  describe 'downcase type' do
    it 'can convert' do
      value = described_class.call('BUREN', :downcase)
      expect(value).to eq('buren')
    end

    it "returns nil if value can't be converted" do
      value = described_class.call(nil, :downcase)
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertDowncase do
  describe 'downcase! type' do
    it 'can convert' do
      value = described_class.call('BUREN', :downcase!)
      expect(value).to eq('buren')
    end

    it 'can return unchanged' do
      value = described_class.call('buren', :downcase!)
      expect(value).to eq('buren')
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.call(nil, :downcase!)
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertUpcase do
  describe 'upcase type' do
    it 'can convert' do
      value = described_class.call('buren', :upcase)
      expect(value).to eq('BUREN')
    end

    it "returns nil if value can't be converted" do
      value = described_class.call(nil, :upcase)
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertUpcase do
  describe 'upcase! type' do
    it 'can convert' do
      value = described_class.call('buren', :upcase!)
      expect(value).to eq('BUREN')
    end

    it 'can return unchanged' do
      value = described_class.call('BUREN', :downcase!)
      expect(value).to eq('BUREN')
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.call(nil, :upcase!)
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertSymbol do
  describe 'symbol type' do
    it 'can convert' do
      value = described_class.call('1')
      expect(value).to eq(:'1')
    end

    it "returns nil if value can't be converted" do
      value = described_class.call(nil)
      expect(value).to be_nil
    end
  end
end

RSpec.describe HoneyFormat::StrictConvertSymbol do
  describe 'symbol! type' do
    it 'can convert' do
      value = described_class.call('1')
      expect(value).to eq(:"1")
    end

    it 'can return unchanged' do
      value = described_class.call(:'1')
      expect(value).to eq(:'1')
    end

    it "raises ArgumentError if type can't be converted" do
      expect do
        described_class.call(nil)
      end.to raise_error(ArgumentError)
    end
  end
end

RSpec.describe HoneyFormat::ConvertMD5 do
  describe 'md5 type' do
    it 'return nil when given nil' do
      value = described_class.call(nil)
      expect(value).to be_nil
    end

    it 'converts value to MD5' do
      value = described_class.call('buren')
      value1 = described_class.call('buren')

      expect(value).not_to eq('buren')
      expect(value.length).to eq(32)
      expect(value).to eq(value1)
    end
  end
end

RSpec.describe HoneyFormat::ConvertHex do
  describe 'hex type' do
    it 'return nil when given nil' do
      value = described_class.call(nil, :hex)
      expect(value).to be_nil
    end

    it 'converts value to random hex' do
      value = described_class.call('buren', :hex)
      value1 = described_class.call('buren', :hex)

      expect(value).not_to eq('buren')
      expect(value.length).to eq(32)
      expect(value).not_to eq(value1)
    end
  end
end

RSpec.describe HoneyFormat::ConvertBlank do
  describe 'blank type' do
    it 'converts value to empty string' do
      value = described_class.call('buren')
      expect(value).to eq('')
    end
  end
end

RSpec.describe HoneyFormat::ConvertHeaderColumn do
  describe 'header_column type' do
    it 'converts value to header column string' do
      value = described_class.call('(jacob)buren')
      expect(value).to eq(:jacob_buren)
    end
  end
end
