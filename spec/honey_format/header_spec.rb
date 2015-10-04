require 'spec_helper'

describe HoneyFormat::Header do
  let(:missing_header_klass) { HoneyFormat::MissingCSVHeaderError }

  describe '#initialize' do
    it 'fails when header is nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(missing_header_klass)
    end

    it 'fails when header is empty' do
      expect do
        described_class.new([])
      end.to raise_error(missing_header_klass)
    end
  end

  describe '#column_names' do
    it 'can return original column names' do
      value = 'My id (string)'
      expect(described_class.new([value]).column_names).to eq([value])
    end
  end
end
