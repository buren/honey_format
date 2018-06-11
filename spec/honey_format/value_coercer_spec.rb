require 'spec_helper'

require 'honey_format/value_coercer'

RSpec.describe HoneyFormat::ValueCoercer do
  describe "#register" do
    it 'raises Errors::ValueTypeExistsError when trying to register duplicated type' do
      value_coercer = described_class.new
      expect do
        value_coercer.register(:datetime!, proc {})
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

  describe "#coerce" do
    describe "integer! type" do
      it 'can coerce' do
        value = described_class.new.coerce('1', :integer!)
        expect(value).to eq(1)
      end

      it "raises ArgumentError if typ can't be coerced" do
        expect do
          described_class.new.coerce('aa', :integer!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "integer type" do
      it 'can coerce' do
        value = described_class.new.coerce('1', :integer)
        expect(value).to eq(1)
      end

      it "returns nil if value can't be coerced" do
        value = described_class.new.coerce('aa', :integer)
        expect(value).to be_nil
      end
    end

    describe "decimal type" do
      it 'can coerce' do
        value = described_class.new.coerce('1.1', :decimal)
        expect(value).to eq(1.1)
      end

      it 'returns 1.0 if when passed "1"' do
        value = described_class.new.coerce('1', :decimal)
        expect(value).to eq(1.0)
      end

      it "returns nil if value can't be coerced" do
        value = described_class.new.coerce('aa', :decimal)
        expect(value).to be_nil
      end
    end

    describe "decimal! type" do
      it 'can coerce' do
        value = described_class.new.coerce('1.1', :decimal!)
        expect(value).to eq(1.1)
      end

      it 'returns 1.0 if when passed "1"' do
        value = described_class.new.coerce('1', :decimal!)
        expect(value).to eq(1.0)
      end

      it "raise ArgumentError if value can't be coerced" do
        expect do
          described_class.new.coerce('aa', :decimal!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "date! type" do
      it 'can coerce' do
        date_string = '2018-01-01'
        value = described_class.new.coerce(date_string, :date!)
        expected = Date.parse('2018-01-01')
        expect(value).to eq(expected)
      end

      it "raise ArgumentError if value can't be coerced" do
        expect do
          described_class.new.coerce('aa', :date!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "date type" do
      it 'can coerce' do
        date_string = '2018-01-01'
        value = described_class.new.coerce(date_string, :date!)
        expected = Date.parse('2018-01-01')
        expect(value).to eq(expected)
      end

      it "returns nil if value can't be coerced" do
        value = described_class.new.coerce('aa', :date)
        expect(value).to be_nil
      end
    end

    describe "datetime! type" do
      it 'can coerce' do
        time_string = '2018-01-01 00:15'
        value = described_class.new.coerce(time_string, :datetime)
        expected = Time.parse('2018-01-01 00:15')
        expect(value).to eq(expected)
      end

      it "raise ArgumentError if value can't be coerced" do
        expect do
          described_class.new.coerce('aa', :datetime!)
        end.to raise_error(ArgumentError)
      end
    end

    describe "datetime type" do
      it 'can coerce' do
        time_string = '2018-01-01 00:15'
        value = described_class.new.coerce(time_string, :datetime)
        expected = Time.parse('2018-01-01 00:15')
        expect(value).to eq(expected)
      end

      it "returns nil if value can't be coerced" do
        value = described_class.new.coerce('aa', :datetime)
        expect(value).to be_nil
      end
    end

    it 'can coerce custom value' do
      value_coercer = described_class.new
      value_coercer.register(:upcased, proc { |v| v.upcase })
      value = value_coercer.coerce('buren', :upcased)
      expect(value).to eq('BUREN')
    end

    it 'raises ArgumentError if an unknown type is passed' do
      value_coercer = described_class.new
      expect do
        value_coercer.coerce(nil, :watman)
      end.to raise_error(ArgumentError)
    end
  end
end
