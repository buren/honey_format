require 'spec_helper'

require 'honey_format/value_converter'

RSpec.describe HoneyFormat::ValueConverter do
  describe "#register" do
    it 'raises Errors::ValueTypeExistsError when trying to register duplicated type' do
      value_converter = described_class.new
      expect do
        value_converter.register(:datetime!, proc {})
      end.to raise_error(HoneyFormat::Errors::ValueTypeExistsError)
    end
  end

  describe "#types" do
    it 'returns the register types' do
      expected = %i[
        decimal! integer! date! datetime!
        decimal integer date datetime
      ]
      expect(described_class.new.types).to eq(expected)
    end
  end

  describe "#convert" do
    describe "integer! type" do
      it 'can convert' do
        value = described_class.new.convert('1', :integer!)
        expect(value).to eq(1)
      end

      it "raises ArgumentError if typ can't be converted" do
        expect do
          described_class.new.convert('aa', :integer!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "integer type" do
      it 'can convert' do
        value = described_class.new.convert('1', :integer)
        expect(value).to eq(1)
      end

      it "returns nil if value can't be converted" do
        value = described_class.new.convert('aa', :integer)
        expect(value).to be_nil
      end
    end

    describe "decimal type" do
      it 'can convert' do
        value = described_class.new.convert('1.1', :decimal)
        expect(value).to eq(1.1)
      end

      it 'returns 1.0 if when passed "1"' do
        value = described_class.new.convert('1', :decimal)
        expect(value).to eq(1.0)
      end

      it "returns nil if value can't be converted" do
        value = described_class.new.convert('aa', :decimal)
        expect(value).to be_nil
      end
    end

    describe "decimal! type" do
      it 'can convert' do
        value = described_class.new.convert('1.1', :decimal!)
        expect(value).to eq(1.1)
      end

      it 'returns 1.0 if when passed "1"' do
        value = described_class.new.convert('1', :decimal!)
        expect(value).to eq(1.0)
      end

      it "raise ArgumentError if value can't be converted" do
        expect do
          described_class.new.convert('aa', :decimal!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "date! type" do
      it 'can convert' do
        date_string = '2018-01-01'
        value = described_class.new.convert(date_string, :date!)
        expected = Date.parse('2018-01-01')
        expect(value).to eq(expected)
      end

      it "raise ArgumentError if value can't be converted" do
        expect do
          described_class.new.convert('aa', :date!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "date type" do
      it 'can convert' do
        date_string = '2018-01-01'
        value = described_class.new.convert(date_string, :date!)
        expected = Date.parse('2018-01-01')
        expect(value).to eq(expected)
      end

      it "returns nil if value can't be converted" do
        value = described_class.new.convert('aa', :date)
        expect(value).to be_nil
      end
    end

    describe "datetime! type" do
      it 'can convert' do
        time_string = '2018-01-01 00:15'
        value = described_class.new.convert(time_string, :datetime)
        expected = Time.parse('2018-01-01 00:15')
        expect(value).to eq(expected)
      end

      it "raise ArgumentError if value can't be converted" do
        expect do
          described_class.new.convert('aa', :datetime!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "datetime type" do
      it 'can convert' do
        time_string = '2018-01-01 00:15'
        value = described_class.new.convert(time_string, :datetime)
        expected = Time.parse('2018-01-01 00:15')
        expect(value).to eq(expected)
      end

      it "returns nil if value can't be converted" do
        value = described_class.new.convert('aa', :datetime)
        expect(value).to be_nil
      end
    end

    it 'can convert custom value' do
      value_converter = described_class.new
      value_converter.register(:upcased, proc { |v| v.upcase })
      value = value_converter.convert('buren', :upcased)
      expect(value).to eq('BUREN')
    end

    it 'raises ArgumentError if an unknown type is passed' do
      value_converter = described_class.new
      expect do
        value_converter.convert(nil, :watman)
      end.to raise_error(ArgumentError)
    end
  end
end
